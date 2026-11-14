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
    <div style="margin: 10px 0; padding: 12px; border: 1px dashed #c0c4cc; border-radius: 6px;">
        <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
            <strong>模板批量查询：</strong>
            <el-tag type="info" effect="plain">Sheet1（{{ templateRowCount }} 行）</el-tag>
            <el-button :disabled="autoQuerying" @click="loadTemplateSheets(true)">刷新模板</el-button>
            <el-button type="primary" plain @click="openPriceDialog">编辑模板价格</el-button>
            <el-button
                type="success"
                :loading="autoQuerying"
                title="按 Sheet1 逐条查询；某个磨损在 12 小时内已经查过会自动跳过"
                @click="autoQueryFromTemplate"
            >
                按模板自动查询（每条间隔 10 秒）
            </el-button>
            <el-tag type="warning" effect="plain" size="small">12 小时内查过的磨损自动跳过</el-tag>
            <el-button v-if="autoQuerying" type="danger" @click="stopAutoQuery">停止</el-button>
            <span v-if="autoProgress.total" style="color: #606266;">
                {{ autoProgress.current }}/{{ autoProgress.total }} · {{ autoProgress.text }}
            </span>
            <span v-if="templateModifiedAt" style="color: #909399; font-size: 12px;">
                moban.xlsx 修改于 {{ templateModifiedAt }}
            </span>
        </div>
    </div>

    <!-- 编辑模板价格：输入后直接写回 moban.xlsx 的 Sheet1，每一行（每个磨损）可单独保存 -->
    <el-dialog v-model="priceDialogVisible" :title="priceDialogTitle" width="860px" :close-on-click-modal="false">
        <div style="margin-bottom: 10px; font-size: 12px; line-height: 1.7;">
            <div v-if="priceDialogHint" style="color: #e6a23c;">{{ priceDialogHint }}</div>
            <div style="color: #909399;">
                改完某一行的价格，点该行右侧「保存本行」即可单独写入 Excel；也可以点底部「全部保存」。留空 = 把该单元格清空（覆盖为空），写入前会自动备份。
            </div>
        </div>
        <el-table :data="priceRows" border max-height="420" size="small">
            <el-table-column type="index" label="#" width="46" />
            <el-table-column label="名称" min-width="230">
                <template #default="{ row }">
                    <span>{{ row.name }}</span>
                    <el-tag v-if="row.fromC5Query || row.fromBuffQuery" size="small" type="success" effect="plain" style="margin-left: 6px;">
                        查询最低价
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="wear" label="磨损区间" width="105" />
            <el-table-column label="C5出售价格" width="140">
                <template #default="{ row }">
                    <el-input
                        v-model="row.c5Price"
                        size="small"
                        placeholder="留空=清空"
                        :title="priceTitle(row, 'c5')"
                    >
                        <template #prepend>¥</template>
                    </el-input>
                </template>
            </el-table-column>
            <el-table-column label="BUFF出售价格" width="140">
                <template #default="{ row }">
                    <el-input
                        v-model="row.buffPrice"
                        size="small"
                        placeholder="留空=清空"
                        :title="priceTitle(row, 'buff')"
                    >
                        <template #prepend>¥</template>
                    </el-input>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="140" align="center">
                <template #default="{ row }">
                    <el-button
                        type="primary"
                        size="small"
                        :loading="savingRowIndex === row.rowIndex"
                        :disabled="savingRowIndex !== null && savingRowIndex !== row.rowIndex"
                        @click="saveOnePriceRow(row)"
                    >
                        保存本行
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
        <template #footer>
            <span style="float: left; color: #909399; font-size: 12px; line-height: 32px;">
                共 {{ priceRows.length }} 行
            </span>
            <el-button @click="priceDialogVisible = false">关闭</el-button>
            <el-button type="primary" :loading="savingPrices" :disabled="savingRowIndex !== null" @click="saveTemplatePrices">
                全部保存
            </el-button>
        </template>
    </el-dialog>
    <div>
        <el-button type="primary" @click="clearTableData">清空</el-button>
        <el-table :data="tableData" border style="width: 100%">
                    <el-table-column type="index" label="序号" width="64" align="center" />
                    <el-table-column prop="name" label="名称" width="170" />
                    <el-table-column prop="wear" label="磨损" width="150" />
                    <el-table-column prop="type" label="平台" width="150">
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
                    <el-table-column label="价格" width="450">
                        <template #default="{ row }">
                            <div v-if="row.priceGroups && row.priceGroups.length">
                                <div
                                    v-for="group in row.priceGroups"
                                    :key="group.type"
                                    style="margin-bottom: 10px;"
                                >
                                    <strong>{{ group.type }}:</strong>
                                    <div class="price-container">
                                        <!-- 用 span 代替 el-tag：标签数量很多（每行几十个），纯元素渲染开销小得多 -->
                                        <span
                                            v-for="tag in group.tags"
                                            :key="tag.key"
                                            class="price-pill price-tag-clickable"
                                            :class="{ 'price-pill-active': isTagActive(row, group.field, tag.num) }"
                                            :style="tag.style"
                                            :title="`点击把 ${group.type} 改价设为 ¥${tag.text}`"
                                            @click="applyPriceToEdit(row, group.type, tag.text)"
                                        >{{ tag.text }}</span>
                                        <!-- 空值：点击后该平台留空，保存时把 Excel 原价格覆盖为空 -->
                                        <span
                                            class="price-pill price-tag-clickable price-tag-empty"
                                            :class="{ 'price-pill-empty-active': fieldIsEmpty(row, group.field) }"
                                            title="置为空值：保存时把 Excel 里原来的价格覆盖为空"
                                            @click="clearPriceField(row, group.field)"
                                        >空</span>
                                    </div>
                                </div>
                            </div>
                            <span v-else>暂无价格数据</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="时间" width="150" align="center">
                        <template #default="{ row }">
                            <div style="display: flex; flex-direction: column; gap: 4px; font-size: 12px; line-height: 1.5;">
                                <div :title="queryTimeTitle(row)">
                                    <span style="color: #909399;">查询</span>
                                    <span style="color: #303133; margin-left: 4px;">{{ formatTime(row.createdAt) }}</span>
                                </div>
                                <div :title="saveTimes[row._key] ? '上次点「保存此磨损」的时间' : '还没有保存过'">
                                    <span style="color: #909399;">保存</span>
                                    <span :style="saveTimeStyle(row)">{{ formatTime(saveTimes[row._key]) }}</span>
                                </div>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column label="改价（写入 Excel）" width="252" align="center">
                        <template #default="{ row }">
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <div style="display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 30px; text-align: right; color: #909399; font-size: 12px;">C5</span>
                                    <el-input-number
                                        v-model="row.editC5"
                                        :step="0.01"
                                        :precision="2"
                                        :min="0"
                                        :controls="true"
                                        controls-position="right"
                                        size="small"
                                        placeholder="空"
                                        style="flex: 1;"
                                    />
                                    <el-button
                                        link
                                        size="small"
                                        :disabled="row.editC5 == null"
                                        title="置为空值：保存时把 C5 原价格覆盖为空"
                                        @click="clearPriceField(row, 'editC5')"
                                    >✕</el-button>
                                </div>
                                <div style="display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 30px; text-align: right; color: #909399; font-size: 12px;">BUFF</span>
                                    <el-input-number
                                        v-model="row.editBuff"
                                        :step="0.01"
                                        :precision="2"
                                        :min="0"
                                        :controls="true"
                                        controls-position="right"
                                        size="small"
                                        placeholder="空"
                                        style="flex: 1;"
                                    />
                                    <el-button
                                        link
                                        size="small"
                                        :disabled="row.editBuff == null"
                                        title="置为空值：保存时把 BUFF 原价格覆盖为空"
                                        @click="clearPriceField(row, 'editBuff')"
                                    >✕</el-button>
                                </div>
                                <el-button
                                    type="primary"
                                    size="small"
                                    :loading="savingRowKey === row._key"
                                    @click="saveRowPricesInline(row)"
                                >
                                    保存此磨损
                                </el-button>
                            </div>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
            
            <!-- 回到顶部按钮 -->
            <el-backtop :right="100" :bottom="100" />
        </template>

<script setup>
import { ref, onMounted, computed, watch, markRaw } from 'vue'
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

// 每个磨损「保存此磨损」的时间（key = 名称_磨损），存本地，刷新页面后仍在
const SAVE_TIME_STORAGE_KEY = 'cs_sell_save_times'
const saveTimes = ref({})

const loadSaveTimes = () => {
    try {
        const raw = localStorage.getItem(SAVE_TIME_STORAGE_KEY)
        saveTimes.value = raw ? (JSON.parse(raw) || {}) : {}
    } catch (error) {
        console.warn('读取保存时间缓存失败:', error)
        saveTimes.value = {}
    }
}

const persistSaveTimes = () => {
    try {
        localStorage.setItem(SAVE_TIME_STORAGE_KEY, JSON.stringify(saveTimes.value))
    } catch (error) {
        console.warn('写入保存时间缓存失败:', error)
    }
}

const markRowSaved = (row, at) => {
    if (!row || !row._key) return
    saveTimes.value = { ...saveTimes.value, [row._key]: at || Date.now() }
    persistSaveTimes()
}

// 按「名称 + 磨损」标记保存时间（弹窗里保存时用，磨损写法可能不同，需要归一化）
const markSavedByWear = (name, wear, at) => {
    const when = at || Date.now()
    const tn = normName(name)
    const tw = wearKey(wear)
    const next = { ...saveTimes.value }
    let touched = false
    ;(tableData.value || []).forEach(r => {
        if (normName(r.name) === tn && wearKey(r.wear) === tw) {
            next[r._key] = when
            touched = true
        }
    })
    if (touched) {
        saveTimes.value = next
        persistSaveTimes()
    }
}

// 统一解析成 Date（支持 Date / 时间戳 / ISO / MySQL "2026-11-14 23:15:44" 写法）
const toDate = (val) => {
    if (val === null || val === undefined || val === '') return null
    let d
    if (val instanceof Date) {
        d = val
    } else if (typeof val === 'number') {
        d = new Date(val)
    } else {
        // Safari 不认 "YYYY-MM-DD HH:mm:ss"，替换成 T；无时区信息时按东八区
        const s = String(val).trim().replace(' ', 'T')
        d = new Date(/[zZ]|[+-]\d{2}:?\d{2}$/.test(s) ? s : s + '+08:00')
    }
    return isNaN(d.getTime()) ? null : d
}

// 统一时间格式：MM-DD HH:mm:ss
const formatTime = (val) => {
    if (val === null || val === undefined || val === '') return '—'
    const d = toDate(val)
    if (!d) return String(val)
    const p = (n) => String(n).padStart(2, '0')
    return `${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`
}

// 保存时间的颜色：绿色=已保存最新价格；橙色=查询时间比保存时间新（查了还没保存）；灰色=从未保存
const saveTimeStyle = (row) => {
    const savedAt = saveTimes.value[row && row._key]
    if (!savedAt) return 'color: #c0c4cc; margin-left: 4px;'
    const queryAt = toDate(row && row.createdAt)
    if (queryAt && savedAt < queryAt.getTime()) return 'color: #e6a23c; margin-left: 4px; font-weight: 600;'
    return 'color: #67c23a; margin-left: 4px;'
}

// 查询时间的悬浮提示：列出各平台各自的查询时间
const queryTimeTitle = (row) => {
    if (!row || !row.createdAt) return '暂无查询时间'
    const lines = ['价格查询时间：' + formatTime(row.createdAt)]
    const times = row.typeTimes || {}
    Object.keys(times).forEach(t => lines.push(`${t}：${formatTime(times[t])}`))
    return lines.join('\n')
}

// 加载表格数据
const loadTableData = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/records`);
        const result = await response.json();

        if (result.success) {
            // 更新表格数据；同时给每行挂上「改价」用的默认值（= 本次查询的最低价）与唯一 key
            tableData.value = (result.data || []).map(r => {
                const row = { ...r }
                row._key = `${r.name}_${r.wear}`
                // 价格标签的文本 / 颜色在这里一次算好；markRaw 避免上万个标签对象被深度响应式代理（渲染更省）
                row.priceGroups = markRaw(buildPriceGroups(r.price))
                const minC5 = minPriceOf(r.price, 'C5')
                const minBuff = minPriceOf(r.price, 'BUFF')
                row.editC5 = minC5 !== null ? Number(minC5) : null
                row.editBuff = minBuff !== null ? Number(minBuff) : null
                // 记录「初始值」：用于区分「从头就没数据」和「用户把它清空了」
                row.initC5 = row.editC5
                row.initBuff = row.editBuff
                row.clearedC5 = false
                row.clearedBuff = false
                return row
            })
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


// 根据价格生成标签样式：同一价位同色，不同价位不同色（价格由低到高：紫蓝→红，对比更强）
// allPrices 传的是「同一条查询（同一磨损）里所有平台的价格」，即配色以磨损为单位
// 注意：模板里不要直接调用它（每行几十个标签，重复计算会明显掉帧），
// 统一在 loadTableData 里用 buildPriceGroups 预计算好，模板只负责展示。
const priceStyleByRank = (rank, count) => {
    if (count <= 0 || rank == null || rank < 0) {
        return 'background:#f4f4f5;border:1px solid #dcdfe6;color:#909399;';
    }

    let hue, lightness;
    if (count <= 1) {
        hue = 210;
        lightness = 45;
    } else {
        const t = rank / (count - 1);
        // 色相跨度加大：紫蓝(270) → 红(0)，跨越蓝/青/绿/黄/橙，相邻价位差别更明显
        hue = 270 - t * 270;
        // 相邻价位明度交替（亮/暗），进一步拉开对比
        lightness = rank % 2 === 0 ? 45 : 58;
    }

    const saturation = 82;
    const borderColor = `hsl(${hue}, ${saturation}%, ${lightness}%)`;
    const backgroundColor = `hsl(${hue}, ${saturation}%, 94%)`;
    const textColor = `hsl(${hue}, ${saturation}%, ${Math.max(lightness - 12, 22)}%)`;
    return `background:${backgroundColor};border:1px solid ${borderColor};color:${textColor};`;
}

/**
 * 把一条记录的 price 字段预处理成「模板可直接渲染」的结构（在 loadTableData 里调用一次）
 * 返回 [{ type, field, tags: [{ key, text, num, style }] }]
 * 同一磨损下所有平台的价格合并计算色阶，保证同价同色。
 */
const buildPriceGroups = (priceList) => {
    if (!Array.isArray(priceList)) return []

    // 第一遍：解析出每个平台的价格数组
    const groups = []
    const allNums = []
    priceList.forEach(item => {
        if (!item) return
        const values = []
        parsePriceArray(item.price).forEach(v => {
            const n = parseFloat(v)
            if (!isNaN(n)) values.push(n)
        })
        groups.push({ type: item.type, values })
        for (let i = 0; i < values.length; i++) allNums.push(values[i])
    })

    // 整行共用一套色阶；用 Map 记排名，避免每个标签都 indexOf
    const uniquePrices = [...new Set(allNums)].sort((a, b) => a - b)
    const rankMap = new Map()
    uniquePrices.forEach((v, i) => rankMap.set(v, i))
    const count = uniquePrices.length

    return groups.map(g => ({
        type: g.type,
        field: PRICE_TYPE_FIELD[String(g.type || '').toUpperCase()] || null,
        tags: g.values.map((n, i) => ({
            key: g.type + '-' + i,
            text: String(g.values[i]),
            num: Number(n.toFixed(2)),
            style: priceStyleByRank(rankMap.get(n), count)
        }))
    }))
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
            saveTimes.value = {}; // 查询记录清空了，保存时间也一并清掉
            persistSaveTimes();
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
    const buffProxyUrl = `${API_BASE_URL}/buff-proxy?goods_id=${goodsId}&min_paintwear=${minPaintwear}&max_paintwear=${maxPaintwear}&page_size=30`;
    
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
                    pageSize: 30
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

// ===== 模板批量查询（只针对 Sheet1）=====
const TEMPLATE_SHEET = 'Sheet1'
const templateRowCount = ref(0)      // Sheet1 的真实数据行数（不含表头）
const templateModifiedAt = ref('')   // 模板文件最后修改时间
const autoQuerying = ref(false)
const autoProgress = ref({ current: 0, total: 0, text: '' })
let autoCancelled = false

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms))

// 读取 Sheet1 的真实行数（每次「刷新模板」或开始查询前都会重新读盘）
const loadTemplateSheets = async (notify = false) => {
    try {
        const resp = await fetch(`${API_BASE_URL}/template/sheets`)
        const result = await resp.json()
        if (!result.success) {
            if (notify) ElMessage.error(result.message || '读取模板失败')
            return
        }
        templateRowCount.value = result.dataRows || 0
        if (result.modifiedAt) {
            templateModifiedAt.value = new Date(result.modifiedAt).toLocaleString('zh-CN', { hour12: false })
        }
        if (notify) {
            ElMessage.success(`模板已刷新：Sheet1 共 ${templateRowCount.value} 行`)
        }
    } catch (error) {
        console.error('读取模板 Sheet1 信息失败:', error)
        if (notify) ElMessage.error('读取模板失败，请确认后端已启动')
    }
}

// ===== 编辑模板价格（写回 moban.xlsx，可按每个磨损单独保存）=====
const priceDialogVisible = ref(false)
const priceDialogTitle = ref('编辑模板价格（Sheet1）')
const priceDialogHint = ref('')
const priceRows = ref([])
const savingPrices = ref(false)      // 正在「全部保存」
const savingRowIndex = ref(null)     // 正在保存的行号（单个磨损保存）

// 拉取模板里的价格行
const fetchTemplatePriceRows = async () => {
    const resp = await fetch(`${API_BASE_URL}/template?sheet=${encodeURIComponent(TEMPLATE_SHEET)}`)
    const result = await resp.json()
    if (!result.success) {
        ElMessage.error(result.message || '读取模板失败')
        return null
    }
    return (result.data || []).map(r => ({
        rowIndex: r.rowIndex,
        name: r.name,
        wear: r.wear,
        c5Price: r.c5Price,
        buffPrice: r.buffPrice
    }))
}

// 输入框悬浮提示（显示「本次查询最低」与「Excel 原值」，便于核对）
const priceTitle = (row, field) => {
    const isC5 = field === 'c5'
    const fromQuery = isC5 ? row.fromC5Query : row.fromBuffQuery
    const queryMin = isC5 ? row.c5QueryMin : row.buffQueryMin
    const old = isC5 ? row.c5PriceOld : row.buffPriceOld
    const oldText = old != null && String(old).trim() !== '' ? `Excel 原值 ¥${old}` : ''

    if (fromQuery) return `本次查询最低 ¥${queryMin}` + (oldText ? `（${oldText}）` : '')
    return oldText
}

// 打开弹窗：全部磨损（有查询结果的行按「本次查询最低价」预填，其余保留 Excel 原值）
const openPriceDialog = async () => {
    try {
        const rows = await fetchTemplatePriceRows()
        if (rows === null) return
        if (!rows.length) {
            ElMessage.warning('Sheet1 中没有可编辑的数据行')
            return
        }

        // 最近一次查询结果（按 名称+磨损 建索引）：优先取后端最新记录，失败则用页面上已有的数据
        let queryRows = Array.isArray(tableData.value) ? tableData.value : []
        try {
            const recResp = await fetch(`${API_BASE_URL}/records`)
            const recResult = await recResp.json()
            if (recResult && recResult.success && Array.isArray(recResult.data)) queryRows = recResult.data
        } catch (e) {
            console.warn('读取查询结果失败，改用页面已有数据:', e)
        }

        const queryIndex = new Map()
        queryRows.forEach(r => {
            const key = normName(r.name) + '|' + wearKey(r.wear)
            if (!queryIndex.has(key)) queryIndex.set(key, r)
        })

        let c5Count = 0
        let buffCount = 0
        priceRows.value = rows.map(r => {
            const hit = queryIndex.get(normName(r.name) + '|' + wearKey(r.wear))
            const minC5 = hit ? toPriceNumber(minPriceOf(hit.price, 'C5')) : null
            const minBuff = hit ? toPriceNumber(minPriceOf(hit.price, 'BUFF')) : null
            if (minC5 !== null) c5Count++
            if (minBuff !== null) buffCount++
            return {
                ...r,
                c5PriceOld: r.c5Price,
                buffPriceOld: r.buffPrice,
                c5Price: minC5 !== null ? minC5 : r.c5Price,
                buffPrice: minBuff !== null ? minBuff : r.buffPrice,
                c5QueryMin: minC5,
                buffQueryMin: minBuff,
                fromC5Query: minC5 !== null,
                fromBuffQuery: minBuff !== null
            }
        })

        priceDialogTitle.value = `编辑模板价格（Sheet1 · 共 ${rows.length} 个磨损）`
        priceDialogHint.value = (c5Count || buffCount)
            ? `已按最近一次查询的最低价预填：C5 ${c5Count} 行、BUFF ${buffCount} 行；没有查询结果的行仍显示 Excel 原值。确认后点「保存本行」或「全部保存」写入。`
            : '当前还没有查询结果，显示的是 Excel 里已有的价格（用于批量维护）。'
        priceDialogVisible.value = true
    } catch (error) {
        console.error('读取模板价格失败:', error)
        ElMessage.error('读取模板失败，请确认后端已启动')
    }
}

// 磨损归一化，便于把「查询结果的一行」对到模板里的行
const wearKey = (s) => {
    const nums = String(s == null ? '' : s).match(/\d*\.?\d+/g)
    if (!nums || nums.length < 2) return String(s == null ? '' : s).replace(/\s+/g, '')
    return Number(nums[0]).toFixed(3) + '~' + Number(nums[1]).toFixed(3)
}
const normName = (s) => String(s == null ? '' : s).replace(/\s+/g, '').toLowerCase()

// 取某个平台在本次查询里的最低价（返回原始字符串，保留 0.35 / 1 这种写法）
const minPriceOf = (priceList, typeName) => {
    if (!Array.isArray(priceList)) return null
    const item = priceList.find(p => String(p && p.type || '').toUpperCase() === String(typeName).toUpperCase())
    if (!item) return null
    const raw = parsePriceArray(item.price)
    const nums = raw.map(v => parseFloat(v)).filter(n => !isNaN(n))
    if (!nums.length) return null
    const min = Math.min(...nums)
    const hit = raw.find(v => parseFloat(v) === min)
    return hit != null ? String(hit) : String(min)
}

// ===== 点击价格标签 → 填入该行对应平台的改价框 =====
// 平台 → 改价字段，仅这两个平台有 Excel 价格列
const PRICE_TYPE_FIELD = { C5: 'editC5', BUFF: 'editBuff' }

const toPriceNumber = (v) => {
    const n = parseFloat(v)
    return isNaN(n) ? null : Math.round(n * 100) / 100
}

// 点击标签：把该价格写入同一行对应平台的输入框（只改输入框，不落盘）
const applyPriceToEdit = (row, type, price) => {
    const field = PRICE_TYPE_FIELD[String(type || '').toUpperCase()]
    const num = toPriceNumber(price)
    if (!field || num === null) return
    if (savingRowKey.value === row._key) return  // 保存中不允许改
    row[field] = num
    if (field === 'editC5') row.clearedC5 = false
    else row.clearedBuff = false
}

// 预计算版本的「标签是否被选中」：只做数字比较，模板里每帧调用也不会卡
const isTagActive = (row, field, num) => {
    if (!field) return false
    const cur = row[field]
    return cur != null && Math.abs(cur - num) < 0.005
}

// 置为空值：该平台留空，保存时会把 Excel 里原来的价格覆盖为空
const clearPriceField = (row, field) => {
    if (!row || !field) return
    if (!Object.values(PRICE_TYPE_FIELD).includes(field)) return
    if (savingRowKey.value === row._key) return  // 保存中不允许改
    row[field] = null
    if (field === 'editC5') row.clearedC5 = true
    else row.clearedBuff = true
}

// 该平台当前是否为空值（用于「空」标签高亮）
const isPriceFieldEmpty = (row, type) => {
    const field = PRICE_TYPE_FIELD[String(type || '').toUpperCase()]
    return field ? row[field] == null : false
}

// 已经拿到字段名时用这个，少一次 map 查找
const fieldIsEmpty = (row, field) => (field ? row[field] == null : false)

// 模板价格行缓存 + 正在保存的行 key
const templatePriceRows = ref([])
const savingRowKey = ref('')

// 按「名称 + 磨损」把查询结果的一行对到模板里的行（缓存，必要时强制刷新）
const resolveTemplateRow = async (row, forceReload = false) => {
    if (forceReload || !templatePriceRows.value.length) {
        const rows = await fetchTemplatePriceRows()
        if (rows) templatePriceRows.value = rows
    }
    const tw = wearKey(row.wear)
    const tn = normName(row.name)
    let hit = templatePriceRows.value.find(r => normName(r.name) === tn && wearKey(r.wear) === tw)
    if (!hit) hit = templatePriceRows.value.find(r => wearKey(r.wear) === tw)
    return hit || null
}

// 行内改价：只保存当前这一条磨损
// 约定：有数值 → 写入；被清空（原本有值或点了「空」）→ 把该格覆盖为空；从头就没数据 → 不动
const saveRowPricesInline = async (row) => {
    if (savingRowKey.value) return

    const update = { rowIndex: null }
    const cleared = []

    if (row.editC5 != null) {
        update.c5Price = row.editC5
    } else if (row.initC5 != null || row.clearedC5) {
        update.c5Price = null
        cleared.push('C5')
    }

    if (row.editBuff != null) {
        update.buffPrice = row.editBuff
    } else if (row.initBuff != null || row.clearedBuff) {
        update.buffPrice = null
        cleared.push('BUFF')
    }

    if (update.c5Price === undefined && update.buffPrice === undefined) {
        ElMessage.warning('没有需要保存的价格：请填写 C5 / BUFF，或点「空」把该格清空')
        return
    }

    savingRowKey.value = row._key
    try {
        let templateRow = await resolveTemplateRow(row)
        if (!templateRow) {
            // 缓存可能过期（比如刚改过 Excel 行），强制刷新再试一次
            templateRow = await resolveTemplateRow(row, true)
        }
        if (!templateRow) {
            ElMessage.warning(`模板里没有「${row.name}」磨损 ${row.wear} 这一行`)
            return
        }

        update.rowIndex = templateRow.rowIndex
        const result = await postPriceUpdates([update])
        if (!result) return

        const clearText = cleared.length ? `，已清空 ${cleared.join(' / ')}` : ''
        const savedAt = Date.now()
        ElMessage.success(`已保存：${row.name} 磨损 ${row.wear}（更新 ${result.updated} 个单元格${clearText}）`)

        // 记录本次保存时间，显示在「时间」列
        markRowSaved(row, savedAt)

        // 保存后同步本地的「初始值」，避免下次重复判定为清空
        row.initC5 = row.editC5
        row.initBuff = row.editBuff
        row.clearedC5 = false
        row.clearedBuff = false
        await loadTemplateSheets()
    } catch (error) {
        console.error('行内保存价格失败:', error)
        ElMessage.error('保存失败，请确认后端已启动')
    } finally {
        savingRowKey.value = ''
    }
}

// 提交一批价格到后端（统一处理提示）
const postPriceUpdates = async (updates) => {
    const resp = await fetch(`${API_BASE_URL}/template/prices`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ updates })
    })
    const result = await resp.json()
    if (!result.success) {
        ElMessage.error(result.message || '保存失败')
        return null
    }
    if (result.warnings && result.warnings.length) {
        console.warn('部分单元格未写入:', result.warnings)
        ElMessage.warning(result.warnings.join('；'))
    }
    return result
}

// 只保存「当前这一行（这一个磨损）」
const saveOnePriceRow = async (row) => {
    if (savingRowIndex.value !== null) return
    savingRowIndex.value = row.rowIndex
    try {
        const result = await postPriceUpdates([{
            rowIndex: row.rowIndex,
            c5Price: row.c5Price,
            buffPrice: row.buffPrice
        }])
        if (!result) return

        ElMessage.success(`已保存：${row.name} 磨损 ${row.wear}（更新 ${result.updated} 个单元格）`)
        markSavedByWear(row.name, row.wear)
        // 只刷新这一行，其它行正在编辑的内容不受影响
        const rows = await fetchTemplatePriceRows()
        if (rows) {
            const fresh = rows.find(r => r.rowIndex === row.rowIndex)
            if (fresh) {
                row.c5Price = fresh.c5Price
                row.buffPrice = fresh.buffPrice
            }
        }
        await loadTemplateSheets()
    } catch (error) {
        console.error('保存单行价格失败:', error)
        ElMessage.error('保存失败，请确认后端已启动')
    } finally {
        savingRowIndex.value = null
    }
}

// 保存弹窗里的全部行
const saveTemplatePrices = async () => {
    if (savingPrices.value) return
    savingPrices.value = true
    try {
        const updates = priceRows.value.map(r => ({
            rowIndex: r.rowIndex,
            c5Price: r.c5Price,
            buffPrice: r.buffPrice
        }))
        const result = await postPriceUpdates(updates)
        if (!result) return

        ElMessage.success(`已写入 moban.xlsx，更新 ${result.updated} 个单元格`)
        const savedAt = Date.now()
        priceRows.value.forEach(r => markSavedByWear(r.name, r.wear, savedAt))
        const rows = await fetchTemplatePriceRows()
        if (rows) priceRows.value = rows
        await loadTemplateSheets()
    } catch (error) {
        console.error('保存模板价格失败:', error)
        ElMessage.error('保存失败，请确认后端已启动')
    } finally {
        savingPrices.value = false
    }
}

// 在 sell 列表中按名称查找（先精确，再忽略空格/大小写的宽松匹配）
const findSellItem = (name) => {
    const target = String(name || '').trim()
    if (!target) return null
    const hit = sellItems.value.find(x => x.name === target)
    if (hit) return hit
    const norm = s => String(s || '').replace(/\s+/g, '').toLowerCase()
    const nt = norm(target)
    return sellItems.value.find(x => norm(x.name) === nt) || null
}

const stopAutoQuery = () => {
    autoCancelled = true
    autoQuerying.value = false
    ElMessage.info('已请求停止批量查询')
}

// 批量查询时的跳过规则：某个「名称 + 磨损」在 N 小时内查过就不再重复查
const AUTO_QUERY_SKIP_HOURS = 12

// 拉取各磨损最近一次的查询时间，建 名称|磨损 → 时间戳(ms) 的索引
const fetchRecentQueryTimes = async () => {
    const map = new Map()
    try {
        const resp = await fetch(`${API_BASE_URL}/records`)
        const result = await resp.json()
        if (!result.success) return map
        ;(result.data || []).forEach(r => {
            const t = toDate(r.createdAt)
            if (!t) return
            const key = normName(r.name) + '|' + wearKey(r.wear)
            const prev = map.get(key)
            if (!prev || t.getTime() > prev) map.set(key, t.getTime())
        })
    } catch (error) {
        console.warn('读取最近查询时间失败，本次不做跳过：', error)
    }
    return map
}

// 按模板 sheet 里的「名称 + 磨损」逐条查询，每条之间间隔 10 秒
const autoQueryFromTemplate = async () => {
    if (autoQuerying.value) return
    autoQuerying.value = true
    autoCancelled = false
    try {
        // 开始前先重新读一次模板，确保行数与最新 Excel 一致
        await loadTemplateSheets()
        const resp = await fetch(`${API_BASE_URL}/template?sheet=${encodeURIComponent(TEMPLATE_SHEET)}`)
        const result = await resp.json()
        if (!result.success) {
            ElMessage.error(result.message || '读取模板失败')
            return
        }
        const rows = (result.data || []).filter(r => r.name)
        if (!rows.length) {
            ElMessage.warning('模板中没有可查询的数据行')
            return
        }

        // 最近查询时间（用于「12 小时内已查过就跳过」）
        const recentTimes = await fetchRecentQueryTimes()
        const skipWindowMs = AUTO_QUERY_SKIP_HOURS * 60 * 60 * 1000

        autoProgress.value = { current: 0, total: rows.length, text: '' }
        let okCount = 0
        let skipCount = 0
        let freshCount = 0

        for (let i = 0; i < rows.length; i++) {
            if (autoCancelled) break
            const row = rows[i]

            // 12 小时内查过的磨损直接跳过（不请求接口、也不占用 10 秒间隔）
            const lastAt = recentTimes.get(normName(row.name) + '|' + wearKey(row.wear))
            if (lastAt && (Date.now() - lastAt) < skipWindowMs) {
                skipCount++
                freshCount++
                autoProgress.value.current = i + 1
                autoProgress.value.text = `已跳过（${AUTO_QUERY_SKIP_HOURS} 小时内查过）：${row.name} ${row.wear}`
                console.log(`[跳过] ${row.name} ${row.wear}，上次查询：${formatTime(lastAt)}`)
                continue
            }

            autoProgress.value.text = `查询中 (${i + 1}/${rows.length})：${row.name} ${row.wear}`

            const item = findSellItem(row.name)
            if (!item) {
                skipCount++
                console.warn('模板中的商品在 sell 表中未找到，已跳过：', row.name, row.wear)
                ElMessage.warning(`未匹配到商品，已跳过：${row.name}`)
            } else {
                // 复用现有查询流程：设置当前商品与磨损后调用 submitForm
                selectedSellItem.value = item
                formData.value.sellName = item.name
                formData.value.minWear = row.minWear
                formData.value.maxWear = row.maxWear
                await submitForm()
                okCount++
                recentTimes.set(normName(row.name) + '|' + wearKey(row.wear), Date.now())
            }

            autoProgress.value.current = i + 1

            // 每条之间间隔 10 秒（最后一条不等）
            if (i < rows.length - 1 && !autoCancelled) {
                for (let s = 10; s > 0; s--) {
                    if (autoCancelled) break
                    autoProgress.value.text = `等待 ${s} 秒后查询下一条...`
                    await sleep(1000)
                }
            }
        }

        const skipText = skipCount ? `，跳过 ${skipCount} 条（其中 ${freshCount} 条为 ${AUTO_QUERY_SKIP_HOURS} 小时内已查过）` : ''
        if (autoCancelled) {
            ElMessage.info(`批量查询已停止（成功 ${okCount}${skipText}）`)
        } else {
            ElMessage.success(`批量查询完成（成功 ${okCount}${skipText}）`)
        }
    } catch (error) {
        console.error('模板批量查询失败:', error)
        ElMessage.error('模板批量查询出错，请检查后端是否启动')
    } finally {
        autoQuerying.value = false
        autoProgress.value.text = ''
    }
}

// 在页面加载完成后加载表格数据
onMounted(async () => {
    loadSaveTimes(); // 读取本地的「保存时间」记录
    await loadTokens();
    await loadSellItems();
    await loadTableData(); // 新增：加载表格数据
    await loadTemplateSheets(); // 读取模板各 sheet 的真实行数
});

</script>

<style scoped>
/* 价格标签容器 */
.price-container {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
    margin-top: 4px;
}

/* 价格标签：替代 el-tag（尺寸对齐 el-tag--small），纯元素渲染，标签多时更流畅 */
.price-pill {
    display: inline-flex;
    align-items: center;
    height: 22px;
    padding: 0 7px;
    font-size: 12px;
    line-height: 1;
    border-radius: 4px;
    border: 1px solid transparent;
    box-sizing: border-box;
    white-space: nowrap;
    flex-shrink: 0;
    background: #f4f4f5;
    color: #909399;
    will-change: transform;
}

/* 当前改价框选中的价位：蓝圈 + 加粗 */
.price-pill-active {
    box-shadow: 0 0 0 2px #409eff;
    font-weight: 700;
}

/* 「空」标签 */
.price-tag-empty {
    background: #fafafa;
    border: 1px dashed #c0c4cc;
    color: #909399;
}

.price-pill-empty-active {
    background: #ecf5ff;
    border: 1px dashed #409eff;
    color: #409eff;
    font-weight: 700;
}

/* 价格标签可点击：提示可点、悬停微浮起 */
.price-tag-clickable {
    cursor: pointer;
    user-select: none;
    transition: transform 0.12s ease, filter 0.12s ease;
}

.price-tag-clickable:hover {
    transform: translateY(-1px);
    filter: brightness(1.05);
}

.price-tag-clickable:active {
    transform: translateY(0);
    filter: brightness(0.96);
}
</style>