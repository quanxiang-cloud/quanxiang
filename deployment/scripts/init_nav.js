const NAV_LIST = [
    {
        "id": "app_views",
        "title": "应用视图",
        "icon": "view",
        "children": [
            {
                "id": "views",
                "title": "页面管理",
                "icon": "note_detail_duotone"
            },
            {
                "id": "view_layout",
                "title": "母版管理",
                "icon": "row_top_duotone"
            },
            {
                "id": "app_nav",
                "title": "应用导航",
                "icon": "tab_duotone"
            }
        ]
    },
    {
        "id": "modal_api",
        "title": "数据管理",
        "icon": "gateway",
        "children": [
            {
                "id": "data_models",
                "title": "数据模型管理",
                "icon": "database"
            },
            {
                "id": "api_proxy",
                "title": "第三方 API 代理",
                "icon": "api_outside"
            },
            {
                "id": "orchestration_api",
                "title": "API 编排管理",
                "icon": "api_arrange"
            },
            {
                "id": "faas",
                "title": "FaaS 函数管理",
                "icon": "faas_control"
            },
            {
                "id": "key_api",
                "title": "API 密钥管理",
                "icon": "api_key"
            },
            {
                "id": "file_api",
                "title": "API 文档",
                "icon": "api_inner"
            }
        ]
    },
    {
        "id": "setting_flow",
        "title": "工作流",
        "icon": "data_model"
    },
    {
        "id": "app_control",
        "title": "访问控制",
        "icon": "role"
    },
    {
        "id": "base_info",
        "title": "应用设置",
        "icon": "app_setting"
    }
]

__httpClient('/api/v1/persona/batchSetValue', { keys: [{ key: 'PORTAL_APPLICATION_SIDE_NAV', version: '0.1.0', value: JSON.stringify(NAV_LIST) }] })