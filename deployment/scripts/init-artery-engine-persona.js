const allPackages = [
  {
    name: 'all',
    label: '所有组件',
    version: '1.0.0',
  },
  {
    name: 'system-components',
    label: '系统组件',
    version: '1.0.0',
  },
  {
    name: '@one-for-all/icon',
    label: '图标库',
    version: '0.6.2',
    categories: [
      'action',
      'alert',
      'av',
      'background',
      'communication',
      'content',
      'device',
      'editor',
      'file',
      'hardware',
      'home',
      'image',
      'maps',
      'mobile',
      'navigation',
      'notification',
      'places',
      'qxp_ui',
      'social',
      'toggle',
    ],
  },
  {
    name: '@one-for-all/headless-ui',
    label: 'headless-ui',
    version: '0.8.3',
    categories: [
      '基础组件',
      '表单组件',
      '高级组件',
    ],
  },
];

const headlessUIPropsSpecURL = 'https://ofapkg.pek3b.qingstor.com/@one-for-all/headless-ui@latest/props-spec.json';
const headlessUIManifestURL = 'https://ofapkg.pek3b.qingstor.com/@one-for-all/headless-ui@latest/manifest.json';
const iconManifestURL = 'https://ofapkg.pek3b.qingstor.com/artery-engine-person-initialize-json/one-for-all-icon-manifest.json';
const iconPropsPSpecURL = 'https://ofapkg.pek3b.qingstor.com/artery-engine-person-initialize-json/one-for-all-icon-props-spec.json';
const systemComponentManifestURL = 'https://ofapkg.pek3b.qingstor.com/artery-engine-person-initialize-json/system-component-manifest.json';
const systemComponentPropsSpecURL = 'https://ofapkg.pek3b.qingstor.com/artery-engine-person-initialize-json/system-component-props-spec.json';

Promise.all([
  fetch(headlessUIPropsSpecURL).then((res) => res.text()),
  fetch(headlessUIManifestURL).then((res) => res.text()),
  fetch(iconManifestURL).then((res) => res.text()),
  fetch(iconPropsPSpecURL).then((res) => res.text()),
  fetch(systemComponentManifestURL).then((res) => res.text()),
  fetch(systemComponentPropsSpecURL).then((res) => res.text()),
]).then(([
  headlessUIPropsSpec,
  headlessUIManifest,
  iconManifest,
  iconPropsPSpec,
  systemComponentManifest,
  systemComponentPropsSpec,
]) => {
  const keys = [
    {
      key: 'PACKAGE_PROPS_SPEC:@one-for-all/headless-ui',
      version: '0.8.3',
      value: headlessUIPropsSpec,
    },
    {
      key: 'PACKAGE_MANIFEST:@one-for-all/headless-ui',
      version: '0.8.3',
      value: headlessUIManifest,
    },
    {
      key: 'PACKAGE_MANIFEST:@one-for-all/icon',
      version: '0.6.2',
      value: iconManifest,
    },
    {
      key: 'PACKAGE_PROPS_SPEC:@one-for-all/icon',
      version: '0.6.2',
      value: iconPropsPSpec,
    },
    {
      key: 'PACKAGE_MANIFEST:system-components',
      version: '1.0.0',
      value: systemComponentManifest,
    },
    {
      key: 'PACKAGE_PROPS_SPEC:system-components',
      version: '1.0.0',
      value: systemComponentPropsSpec,
    },
    {
      key: 'PACKAGES',
      version: '1.0.0',
      value: JSON.stringify(allPackages),
    },
  ];

  return window.__httpClient('/api/v1/persona/batchSetValue', { keys });
}).then(() => console.log('artery-engine persona initialized'));
