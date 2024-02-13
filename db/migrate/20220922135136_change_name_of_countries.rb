class ChangeNameOfCountries < ActiveRecord::Migration[6.0]
  def change
    Country.find_by(name_eng: 'United States of America (USA)')&.update(name_eng: 'United States')
    Country.find_by(name_eng: 'Korea South')&.update(name_eng: 'South Korea')
    Country.find_by(name_eng: 'South Korea')&.update(continent: 'Asia')
    Country.find_by(name_eng: 'Taiwan')&.update(continent: 'Asia')
    Country.find_by(name_eng: 'Canada')&.update(continent: 'America')
    Country.find_by(name_eng: 'Brazil')&.update(continent: 'America')
    Country.find_by(name_eng: '')&.update(name_eng: '')
  end
end
