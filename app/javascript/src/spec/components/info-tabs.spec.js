import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';
import InfoTabs from '../../components/info-tabs.vue';
import VlMobileCard from '../../components/shared/vl-mobile-card.vue';

const mocks = {
  selectAccount: jest.fn(),
  $t: jest.fn(),
};
const headers = [
  { title: 'amountUpdatedBalance', filter: 'currency' },
  { title: 'incomesPercentage', filter: 'percent' },
  { title: 'relativeWeight', filter: 'percent' },
];
const bank = { id: 1, name: 'Test bank' };
const membershipOne = {
  id: 1,
  investmentAsset: {
    id: 1,
    assetId: 'ARKQ',
    name: 'ARK ETF TR AUTONOMOUS TECHNOLOGY & ROBOTICS ETF',
  },
};
const subAccountOne = {
  id: 1,
  subAccountId: 'Sub account one',
  currency: 'CLP',
  memberships: [membershipOne],
};
const accountOne = {
  id: 1,
  bank,
  name: 'Test investments',
  rut: '11.111.111-1',
  subAccounts: [subAccountOne],
};
const selectedAccount = '1';

describe('info-card specs', () => {
  function mountTabs() {
    return shallowMount(InfoTabs, {
      mocks,
      propsData: {
        dollarPrice: 750,
        headers,
        selectedAccount,
        accounts: [accountOne],
        selectedAccountInfo: accountOne,
        selectedSubAccountInfo: subAccountOne,
      },
    });
  }

  describe('tabs display', () => {
    const wrapper = mountTabs();
    it('displays accounts', () => {
      expect(wrapper.text()).toMatch('Cuentas');
    });
    it('displays sub accounts', () => {
      expect(wrapper.text()).toMatch('Portafolios');
    });
    it('displays shares', () => {
      expect(wrapper.text()).toMatch('Instrumentos');
    });
  });

  describe('tab changes', () => {
    let wrapper;
    let card;
    describe('select account', () => {
      beforeEach(() => {
        wrapper = mountTabs();
        card = wrapper.findAllComponents(VlMobileCard).at(0);
        card.vm.$emit('click');
      });

      it('moves to sub accounts tab', () => {
        expect(wrapper.vm.$data.selectedTab).toBe('subAccounts');
      });
    });

    describe('select sub-account', async () => {
      wrapper = mountTabs();
      wrapper.setData({ selectedTab: 'subAccounts' });
      await Vue.nextTick();
      card = wrapper.findAllComponents(VlMobileCard).at(0);
      card.vm.$emit('click');

      it('moves to memberships tab', () => {
        expect(wrapper.vm.$data.selectedTab).toBe('memberships');
      });
    });
  });
});
