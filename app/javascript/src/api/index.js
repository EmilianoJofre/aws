import axios from 'axios';
import * as humps from 'humps';

axios.interceptors.request.use(config => {
  const newConfig = { ...config };
  if (newConfig.headers['Content-Type'] === 'multipart/form-data') {
    return newConfig;
  }
  if (config.params) {
    newConfig.params = humps.decamelizeKeys(config.params);
  }
  if (config.data) {
    newConfig.data = humps.decamelizeKeys(config.data);
  }

  return newConfig;
});

function api(options) {
  const tokenEl = document && document.querySelector('meta[name="csrf-token"]');
  const CSRFToken = tokenEl && tokenEl.getAttribute('content');

  return axios({
    ...options,
    withCredentials: true,
    headers: {
      'X-CSRF-Token': CSRFToken,
      ...options.headers,
    },
  }).then(response => Object.assign(
    humps.camelizeKeys(response.data), { headers: response.headers, data: response.data },
  ));
}

export default api;
