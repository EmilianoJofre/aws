import { shallowMount } from '@vue/test-utils';
import TimeSelector from '../../../components/clients/time-selector.vue';

const options = [
  { name: '1M', timeInDays: 30 },
  { name: '6M', timeInDays: 180 },
  { name: 'YTD', timeInDays: 150 },
];

const lastUpdated = '2021-08-11 14:01:06 UTC';

describe('mobile-card specs', () => {
  function mountTimeSelector() {
    return shallowMount(TimeSelector, {
      propsData: { selectedTab: '1M', options, lastUpdated },
      mocks: { $t: jest.fn() },
      computed: {
        filteredLastUpdated() {
          return '11-08-2021';
        },
      },
    });
  }

  describe('on click on tab', () => {
    const wrapper = mountTimeSelector();
    describe('click on already selected tab', () => {
      it('doesnt emits selected-time-tab', () => {
        wrapper.find('.text-vl-blue').trigger('click');
        expect(wrapper.emitted()['selected-time-tab']).toBeFalsy();
      });
    });
    describe('click on not selected tab', () => {
      it('emits selected-time-tab on click', () => {
        wrapper.find('.text-vl-gray').trigger('click');
        expect(wrapper.emitted()['selected-time-tab']).toBeTruthy();
      });
    });
  });
});
