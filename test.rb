require 'webdrivers'
require 'capybara/dsl'
require 'pry'

require 'minitest/autorun'

BASE_URL='https://dfk-paris.org/de/page/ownrealitydatenbank-und-recherche-1353.html'

Capybara.configure do |c|
  c.default_max_wait_time = 5
end

Capybara.current_driver = :selenium_chrome

describe 'OwnReality' do
  include Capybara::DSL

  before do
    visit BASE_URL
    current_window.resize_to 1600, 900
  end

  it 'should paginate' do
    assert_text '1 ... 257'
    assert_no_text 'Les Immatériaux'
    click_on 'nächste Seite'
    assert_text '1 2 ... 257'
    assert_text 'Les Immatériaux'
  end

  it 'should show facet details' do
    all('.or-bucket')[0].find('.or-show-all').click
    assert_text 'Index A'
    assert_text 'A. H. , A. H. (Autor)'
    select 'B (1115)'
    assert_text 'Index B'
    assert_text 'Baader, Andreas (Person)'
  end

  it 'should show results in all categories' do
    assert_text 'Artikel (2560)'
    assert_text 'Ausstellungen (1478)'
    assert_text 'Interviews (16)'
    assert_text 'Zeitschriften (19)'
    assert_text 'Fallstudien (31)'
  end

  it 'should not offer PDF downloads' do
    find('.or-item', text: /Einmischung in die brennenden Fragen/).click
    medium = find('.or-medium img')
    assert_match /blurred/, medium['src']
    medium.assert_no_selector 'a'
  end
end
