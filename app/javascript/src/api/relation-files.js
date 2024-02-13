import api from './index';

function basePath(route) {
  return `/api/v1/${route}`;
}

export default {
  createRelationFile(relationId, data) {
    return api({
      method: 'post',
      url: basePath(`relations/${relationId}/relation_files`),
      headers: { 'Content-Type': 'multipart/form-data' },
      data,
    });
  },
  destroyFile(relationFileId) {
    return api({
      method: 'delete',
      url: basePath(`relation_files/${relationFileId}`),
    });
  },
  getFiles(relationId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(`relations/${relationId}/relation_files`),
      params: { isDemo },
    });
  },
  updateFile(relationFileId, data) {
    return api({
      method: 'patch',
      url: basePath(`relation_files/${relationFileId}`),
      headers: { 'Content-Type': 'multipart/form-data' },
      data,
    });
  },
  download(relationFileId) {
    return api({
      method: 'get',
      url: basePath(`relation_files/${relationFileId}/download`),
      responseType: 'blob',
    });
  },
  downloadMultiple(relationFileIds) {
    const queryIds = `?ids[]=${relationFileIds.join('&ids[]=')}`;

    return api({
      method: 'get',
      url: basePath(`relation_files/download_multiple${queryIds}`),
      responseType: 'blob',
    });
  },
  downloadFiles(relationId, selectedAccountsIds, windowTableSelected, currency, isDemo, type, name) {
    const queryIds = `?ids[]=${selectedAccountsIds.join('&ids[]=')}`;
    const validateIfIsDemo = `${isDemo ? '&demo=true' : ''}`;
    return api({
      method: 'get',
      url: `${relationId}/${name}${queryIds}&window=${windowTableSelected}&currency=${currency}&assetvalue=${type}${validateIfIsDemo}`,
      responseType: 'blob',
    });
  }
};