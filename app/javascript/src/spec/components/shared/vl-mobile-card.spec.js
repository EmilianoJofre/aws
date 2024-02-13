import { shallowMount } from '@vue/test-utils';
import VlMobileCard from '../../../components/shared/vl-mobile-card.vue';

const testTitle = 'Test title';
const testSubTitle = 'Test sub title';
const testDescription = 'Test description';

describe('mobile-card specs', () => {
  function mountCard() {
    return shallowMount(VlMobileCard, {
      propsData: { title: testTitle, subTitle: testSubTitle, description: testDescription },
    });
  }

  describe('props display', () => {
    const wrapper = mountCard();
    it('displays title', () => {
      expect(wrapper.text()).toMatch(testTitle);
    });
    it('displays sub title', () => {
      expect(wrapper.text()).toMatch(testSubTitle);
    });
    it('displays description', () => {
      expect(wrapper.text()).toMatch(testDescription);
    });
  });

  describe('emits', () => {
    it('emits click on click', () => {
      const wrapper = mountCard();
      wrapper.findAll('div').at(1).trigger('click');
      expect(wrapper.emitted().click).toBeTruthy();
    });
  });
});
