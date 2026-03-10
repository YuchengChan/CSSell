<template>
    <div>
        <el-form :model="formData" ref="formRef" :rules="rules" label-width="120px">
            <el-form-item label="BUFF Token">
                <div style="display: flex; align-items: center;">
                    <el-input v-model="formData.buffToken" placeholder="请输入BUFF Token"></el-input>
                    <el-button type="primary" @click="submitBuffToken">提交</el-button>
                </div>
            </el-form-item>
        </el-form>
        <el-form :model="formData" ref="formRef" :rules="rules" label-width="120px">
            <el-form-item label="C5 Token">
                <div style="display: flex; align-items: center;">
                    <el-input v-model="formData.c5Token" placeholder="请输入C5 Token"></el-input>
                    <el-button type="primary" @click="submitC5Token">提交</el-button>   
                </div>
            </el-form-item>
        </el-form>
    </div>
    <div style="margin-top: 20px;">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="选择商品">
                <el-autocomplete v-model="formData.sellName" :fetch-suggestions="querySearch" placeholder="请输入或选择商品"
                    style="width: 300px;" @select="handleSellSelect" clearable>
                    <template #default="{ item }">
                        <div>{{ item.name }}</div>
                    </template>
                </el-autocomplete>
            </el-form-item>
            <el-form-item label="最小磨损">
                <el-select v-model="formData.minWear" placeholder="请选择最小磨损" style="width: 300px;">
                    <el-option 
                        v-for="option in minWearOptions" 
                        :key="option.value" 
                        :label="option.label" 
                        :value="option.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="最大磨损">
                <el-select v-model="formData.maxWear" placeholder="请选择最大磨损" style="width: 300px;">
                    <el-option 
                        v-for="option in maxWearOptions" 
                        :key="option.value" 
                        :label="option.label" 
                        :value="option.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="submitForm">查询</el-button>
            </el-form-item>
        </el-form>
        <el-checkbox-group v-model="selectedPlatforms">
            <el-checkbox label="BUFF" value="BUFF">BUFF</el-checkbox>
            <el-checkbox label="UU" value="UU">UU</el-checkbox>
            <el-checkbox label="C5" value="C5">C5</el-checkbox>
        </el-checkbox-group>
        <el-button type="primary" @click="save">保存</el-button>
    </div>
    <div>
        <el-button type="primary" @click="clearTableData">清空</el-button>
        <el-table :data="tableData" border style="width: 100%">
                    <el-table-column prop="name" label="名称" width="180" />
                    <el-table-column prop="wear" label="磨损" width="180" />
                    <el-table-column prop="type" label="平台" width="180">
                        <template #default="{ row }">
                            <div v-if="Array.isArray(row.type)">
                                <el-tag 
                                    v-for="platform in row.type" 
                                    :key="platform"
                                    size="small"
                                    style="margin-right: 4px; margin-bottom: 4px;"
                                >
                                    {{ platform }}
                                </el-tag>
                            </div>
                            <span v-else>{{ row.type }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="价格" width="500">
                        <template #default="{ row }">
                            <div v-if="row.price && Array.isArray(row.price)">
                                <div 
                                    v-for="priceInfo in row.price" 
                                    :key="priceInfo.type"
                                    style="margin-bottom: 10px;"
                                >
                                    <strong>{{ priceInfo.type }}:</strong>
                                    <div class="price-container" style="display: flex; flex-wrap: wrap; gap: 4px; margin-top: 4px;">
                                        <el-tag 
                                            v-for="(price, index) in parsePriceArray(priceInfo.price)" 
                                            :key="index" 
                                            :type="getPriceTagType(price, parsePriceArray(priceInfo.price))"
                                            size="small" 
                                            style="flex-shrink: 0;"
                                        >
                                            {{ price }}
                                        </el-tag>
                                    </div>
                                </div>
                            </div>
                            <span v-else>暂无价格数据</span>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
            
            <!-- 回到顶部按钮 -->
            <el-backtop :right="100" :bottom="100" />
        </template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'

const buffToken = ref('')
const uuToken = ref('')
const formRef = ref()

const formData = ref({
    buffToken: '',
    uuToken: '',
    c5Token: '',
    tokenType: '',
    sellName: '',
    minWear: '',
    maxWear: ''
})

const selectedPlatforms = ref(['BUFF'])  // 默认选中BUFF

const sellItems = ref([])
const selectedSellItem = ref(null)

// 表格数据
const tableData = ref([])

// 监听最小磨损值的变化，自动设置对应的最大磨损值
watch(() => formData.value.minWear, (newMinWear) => {
  if (newMinWear) {
    // 定义最小磨损值到最大磨损值的映射关系
    const wearMap = {
      '0.00': '0.01',
      '0.01': '0.02',
      '0.02': '0.03',
      '0.03': '0.04',
      '0.07': '0.08',
      '0.08': '0.09',
      '0.09': '0.10',
      '0.15': '0.18',
      '0.18': '0.21'
    };
    
    // 如果当前最大磨损值与推荐值不同，则更新它
    if (wearMap[newMinWear] && formData.value.maxWear !== wearMap[newMinWear]) {
      // 确保推荐的最大磨损值在当前可用选项中
      const availableMaxOptions = maxWearOptions.value.map(option => option.value);
      if (availableMaxOptions.includes(wearMap[newMinWear])) {
        formData.value.maxWear = wearMap[newMinWear];
      }
    }
  }
});

// 根据商品名称动态生成磨损选项
const minWearOptions = computed(() => {
  if (!formData.value.sellName) return getAllMinWearOptions();
  
  if (formData.value.sellName.includes('(崭新出厂)')) {
    return [
      { label: '0.00', value: '0.00' },
      { label: '0.01', value: '0.01' },
      { label: '0.02', value: '0.02' },
      { label: '0.03', value: '0.03' }
    ];
  } else if (formData.value.sellName.includes('(略有磨损)')) {
    return [
      { label: '0.07', value: '0.07' },
      { label: '0.08', value: '0.08' },
      { label: '0.09', value: '0.09' }
    ];
  } else if (formData.value.sellName.includes('(久经沙场)')) {
    return [
      { label: '0.15', value: '0.15' },
      { label: '0.18', value: '0.18' }
    ];
  } else {
    // 默认返回所有选项
    return getAllMinWearOptions();
  }
});

const maxWearOptions = computed(() => {
  if (!formData.value.sellName) return getAllMaxWearOptions();
  
  if (formData.value.sellName.includes('(崭新出厂)')) {
    return [
      { label: '0.01', value: '0.01' },
      { label: '0.02', value: '0.02' },
      { label: '0.03', value: '0.03' },
      { label: '0.04', value: '0.04' }
    ];
  } else if (formData.value.sellName.includes('(略有磨损)')) {
    return [
      { label: '0.08', value: '0.08' },
      { label: '0.09', value: '0.09' },
      { label: '0.10', value: '0.10' }
    ];
  } else if (formData.value.sellName.includes('(久经沙场)')) {
    return [
      { label: '0.18', value: '0.18' },
      { label: '0.21', value: '0.21' }
    ];
  } else {
    // 默认返回所有选项
    return getAllMaxWearOptions();
  }
});

// 获取所有最小磨损选项
const getAllMinWearOptions = () => [
  { label: '0.00', value: '0.00' },
  { label: '0.01', value: '0.01' },
  { label: '0.02', value: '0.02' },
  { label: '0.03', value: '0.03' },
  { label: '0.07', value: '0.07' },
  { label: '0.08', value: '0.08' },
  { label: '0.09', value: '0.09' },
  { label: '0.15', value: '0.15' },
  { label: '0.18', value: '0.18' }
];

// 获取所有最大磨损选项
const getAllMaxWearOptions = () => [
  { label: '0.01', value: '0.01' },
  { label: '0.02', value: '0.02' },
  { label: '0.03', value: '0.03' },
  { label: '0.04', value: '0.04' },
  { label: '0.08', value: '0.08' },
  { label: '0.09', value: '0.09' },
  { label: '0.10', value: '0.10' },
  { label: '0.18', value: '0.18' },
  { label: '0.21', value: '0.21' }
];

const rules = ref({
    buffToken: [
        { required: true, message: '请输入BUFF Token', trigger: 'blur' }
    ],
    uuToken: [
        { required: true, message: '请输入UU Token', trigger: 'blur' }
    ]
})

const API_BASE_URL = 'http://localhost:3000/api'

// 页面加载时获取已有的token
const loadTokens = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/tokens`)
        const result = await response.json()

        if (result.success) {
            // 显示数据库中已有的token
            if (result.data.buffToken) {
                formData.value.buffToken = result.data.buffToken
            }
            if (result.data.uuToken) {
                formData.value.uuToken = result.data.uuToken
            }
            if (result.data.c5Token) {
                formData.value.c5Token = result.data.c5Token
            }
        }
    } catch (error) {
        console.error('获取token失败:', error)
    }
}

// 加载sell表中的所有字段数据
const loadSellItems = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/sell/names`)
        const result = await response.json()

        if (result.success) {
            sellItems.value = result.data
        }
    } catch (error) {
        console.error('获取sell表数据失败:', error)
        ElMessage.error('获取商品列表失败')
    }
}

// 处理商品选择变化
const handleSellChange = (selectedName) => {
    if (selectedName) {
        const selectedItem = sellItems.value.find(item => item.name === selectedName)
        if (selectedItem) {
            selectedSellItem.value = selectedItem
            console.log('选中的商品信息:', selectedSellItem.value)
        }
    } else {
        selectedSellItem.value = null
    }
}

// 查询搜索建议
const querySearch = (queryString, cb) => {
    const results = queryString
        ? sellItems.value.filter(item => item.name.toLowerCase().includes(queryString.toLowerCase()))
        : sellItems.value
    cb(results)
}

// 处理商品选择（自动完成）
const handleSellSelect = (item) => {
    selectedSellItem.value = item
    formData.value.sellName = item.name
    // 重置磨损值，因为选项会根据商品名称变化
    formData.value.minWear = ''
    formData.value.maxWear = ''
    
    // 根据商品名称自动设置默认磨损值
    if (formData.value.sellName.includes('(崭新出厂)')) {
        formData.value.minWear = '0.00'
        formData.value.maxWear = '0.01'
    } else if (formData.value.sellName.includes('(略有磨损)')) {
        formData.value.minWear = '0.07'
        formData.value.maxWear = '0.08'
    } else if (formData.value.sellName.includes('(久经沙场)')) {
        formData.value.minWear = '0.15'
        formData.value.maxWear = '0.18'
    }
    
    console.log('选中的商品信息:', selectedSellItem.value)
}

const submitToken = async (tokenType, tokenValue) => {
    try {
        const response = await fetch(`${API_BASE_URL}/tokens`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                tokenType,
                tokenValue
            })
        })

        const result = await response.json()

        if (result.success) {
            ElMessage.success(`${tokenType.toUpperCase()} Token ${formData.value[`${tokenType}Token`] ? '更新' : '保存'}成功`)
        } else {
            ElMessage.error(result.message || '保存失败')
        }
    } catch (error) {
        console.error('保存token失败:', error)
        ElMessage.error('网络错误，请检查后端服务器是否启动')
    }
}

const submitBuffToken = async () => {
    try {
        await formRef.value.validateField('buffToken')
        if (formData.value.buffToken) {
            await submitToken('buff', formData.value.buffToken)
        }
    } catch (error) {
        console.error('验证失败:', error)
    }
}

const submitUuToken = async () => {
    try {
        await formRef.value.validateField('uuToken')
        if (formData.value.uuToken) {
            await submitToken('uu', formData.value.uuToken)
        }
    } catch (error) {
        console.error('验证失败:', error)
    }
}

// 提交C5 Token
const submitC5Token = async () => {
    try {
        await formRef.value.validateField('c5Token')
        if (formData.value.c5Token) {
            await submitToken('c5', formData.value.c5Token)
        }
    } catch (error) {
        console.error('验证失败:', error)
    }
}

// 页面加载时获取已有的token和sell表数据
onMounted(async () => {
    await loadTokens()
    await loadSellItems()
})



// 保存数据到record表
const save = async () => {
    if (!formData.value.sellName) {
        ElMessage.warning('请先选择一个商品')
        return
    }

    if (selectedPlatforms.value.length === 0) {
        ElMessage.warning('请至少选择一个平台');
        return;
    }

    // 组合磨损信息
    const wearInfo = `${formData.value.minWear || '无'}-${formData.value.maxWear || '无'}`;
    
    // 将选中的多个平台合并为一个字符串
    const combinedType = selectedPlatforms.value.join(',');

    try {
        // 发送数据到后端API保存到record表
        const response = await fetch(`${API_BASE_URL}/records`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                name: formData.value.sellName,
                wear: wearInfo,
                type: combinedType
            })
        });

        const result = await response.json();

        if (result.success) {
            ElMessage.success('数据保存成功');
            
            // 重新加载表格数据以显示最新记录
            await loadTableData();
        } else {
            ElMessage.error(result.message || '保存失败');
        }
    } catch (error) {
        console.error('保存数据失败:', error);
        ElMessage.error('网络错误，请检查后端服务器是否启动');
    }
}

// 加载表格数据
const loadTableData = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/records`);
        const result = await response.json();

        if (result.success) {
            // 更新表格数据
            tableData.value = result.data;
        } else {
            ElMessage.error(result.message || '获取数据失败');
        }
    } catch (error) {
        console.error('获取表格数据失败:', error);
        ElMessage.error('网络错误，请检查后端服务器是否启动');
    }
}

// 解析价格数组
const parsePriceArray = (priceStr) => {
    try {
        if (!priceStr) return [];
        // 如果是字符串，尝试解析JSON
        const parsed = typeof priceStr === 'string' ? JSON.parse(priceStr) : priceStr;
        return Array.isArray(parsed) ? parsed : [];
    } catch (error) {
        console.error('解析价格数组失败:', error);
        // 如果解析失败，尝试以逗号分割字符串
        if (typeof priceStr === 'string') {
            return priceStr.split(',').map(p => p.trim()).filter(p => p);
        }
        return [];
    }
}

// 获取价格标签类型（根据价格高低决定颜色）
const getPriceTagType = (currentPrice, allPrices) => {
    // 将价格转换为数字进行比较
    const currentPriceNum = parseFloat(currentPrice);
    if (isNaN(currentPriceNum)) return 'success'; // 如果无法转换为数字，使用默认颜色
    
    // 找出最低价
    const minPrice = Math.min(...allPrices.map(p => parseFloat(p)).filter(num => !isNaN(num)));
    
    // 如果是最低价，返回primary类型（蓝色），否则返回success类型（绿色）
    return currentPriceNum === minPrice ? 'primary' : 'success';
}

// 清空表格数据
const clearTableData = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/records/clear`, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            ElMessage.success('表格数据已清空');
            tableData.value = []; // 清空本地数据
        } else {
            ElMessage.error(result.message || '清空数据失败');
        }
    } catch (error) {
        console.error('清空表格数据失败:', error);
        ElMessage.error('网络错误，请检查后端服务器是否启动');
    }
}

// 提交表单，向BUFF和C5 API发送请求
const submitForm = async () => {
    if (!selectedSellItem.value) {
        ElMessage.warning('请先选择一个商品')
        return
    }

    // 验证最小磨损不能大于最大磨损
    if (formData.value.minWear && formData.value.maxWear) {
        if (parseFloat(formData.value.minWear) > parseFloat(formData.value.maxWear)) {
            ElMessage.error('最小磨损不能大于最大磨损')
            return
        }
    }

    // 并行执行两个API请求
    const promises = [];

    // 1. 向BUFF API发送请求
    const goodsId = selectedSellItem.value.buffID;
    const minPaintwear = formData.value.minWear;
    const maxPaintwear = formData.value.maxWear;
    const buffProxyUrl = `${API_BASE_URL}/buff-proxy?goods_id=${goodsId}&min_paintwear=${minPaintwear}&max_paintwear=${maxPaintwear}`;
    
    const buffPromise = fetch(buffProxyUrl)
        .then(buffResponse => buffResponse.json())
        .then(buffData => {
            console.log('BUFF API返回数据:', buffData);
            let buffPriceArray = [];
            if (buffData.success && buffData.data && buffData.data.data && buffData.data.data.items) {
                buffPriceArray = buffData.data.data.items.map(item => item.price);
                console.log('提取的BUFF价格数组:', buffPriceArray);
            }
            
            // 保存BUFF数据到record表
            const wearInfo = `${formData.value.minWear || '无'}-${formData.value.maxWear || '无'}`;
            return fetch(`${API_BASE_URL}/records`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    name: formData.value.sellName,
                    wear: wearInfo,
                    type: 'BUFF',  // 平台名称
                    price: JSON.stringify(buffPriceArray)  // 将价格数组转换为JSON字符串存储
                })
            }).then(saveResponse => saveResponse.json())
             .then(saveResult => {
                 if (saveResult.success) {
                     console.log('BUFF数据保存成功');
                 } else {
                     console.error('BUFF数据保存失败:', saveResult.message);
                 }
             });
        })
        .catch(buffError => {
            console.error('BUFF API请求失败:', buffError);
        });

    promises.push(buffPromise);

    // 2. 向C5 API发送请求（通过后端代理）
            const c5ItemId = selectedSellItem.value.c5ID;
            const wearMin = parseFloat(formData.value.minWear) || 0;
            const wearMax = parseFloat(formData.value.maxWear) || 1;

            if (c5ItemId) {
                const c5Promise = fetch(`${API_BASE_URL}/c5-proxy`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                    itemId: String(c5ItemId),  // 传递字符串格式给后端，后端会处理精度问题
                    wearMin: wearMin,
                    wearMax: wearMax,
                    pageSize: 10
                })
                })
                .then(c5Response => c5Response.json())
                .then(c5Data => {
                    console.log('C5 API返回数据:', c5Data);
                    let c5PriceArray = [];
                    // 提取C5价格数据（根据实际返回结构调整）
                    if (c5Data && c5Data.data && c5Data.data.data && c5Data.data.data.list && Array.isArray(c5Data.data.data.list)) {
                        c5PriceArray = c5Data.data.data.list.map(item => item.price);
                    }
                    console.log('提取的C5价格数组:', c5PriceArray);
                    
                    // 保存C5数据到record表
                    const wearInfo = `${formData.value.minWear || '无'}-${formData.value.maxWear || '无'}`;
                    return fetch(`${API_BASE_URL}/records`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            name: formData.value.sellName,
                            wear: wearInfo,
                            type: 'C5',  // 平台名称
                            price: JSON.stringify(c5PriceArray)  // 将价格数组转换为JSON字符串存储
                        })
                    }).then(saveResponse => saveResponse.json())
                     .then(saveResult => {
                         if (saveResult.success) {
                             console.log('C5数据保存成功');
                         } else {
                             console.error('C5数据保存失败:', saveResult.message);
                         }
                     });
                })
                .catch(c5Error => {
                    console.error('C5 API请求失败:', c5Error);
                });

                promises.push(c5Promise);
            }

    // 等待所有请求完成
    try {
        await Promise.all(promises);
        ElMessage.success('API请求成功，数据已在控制台输出并保存到数据库');
        await loadTableData(); // 重新加载表格数据
    } catch (error) {
        console.error('API请求过程中发生错误:', error);
        ElMessage.error('API请求失败');
    }
}

// 在页面加载完成后加载表格数据
onMounted(async () => {
    await loadTokens();
    await loadSellItems();
    await loadTableData(); // 新增：加载表格数据
});

</script>

<style lang="scss" scoped></style>