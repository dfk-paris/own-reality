require "application_system_test_case"

class SearchTest < ApplicationSystemTestCase
  test 'should paginate' do
    assert_text '1 ... 257'
    assert_no_text 'Les Immatériaux'
    click_on 'nächste Seite'
    assert_text '1 2 ... 257'
    assert_text 'Les Immatériaux'
  end

  test 'should show people facet details' do
    all('.or-bucket')[0].find('.or-show-all').click
    assert_text 'Index A'
    assert_text 'A. H. , A. H. (Autor)'
    select 'B (1115)'
    assert_text 'Index B'
    assert_text 'Baader, Andreas (Person)'
  end

  test 'should show results in all categories' do
    assert_text 'Artikel (2560)'
    assert_text 'Ausstellungen (1478)'
    assert_text 'Interviews (16)'
    assert_text 'Zeitschriften (19)'
    assert_text 'Fallstudien (31)'

    within 'or-results' do
      assert_selector '.or-item', count: 10
    end
  end

  test 'should not offer PDF downloads' do
    find('.or-item', text: /Einmischung in die brennenden Fragen/).click
    medium = find('.or-medium img')
    assert_match /blurred/, medium['src']
    medium.assert_no_selector 'a'
  end

  test 'should show country facet details' do
    all('.or-bucket')[12].find('.or-show-all').click
    assert_text 'A (23)'
    assert_text 'Index A'
    assert_text 'Aachen'
    select 'J (3)'
    assert_text 'Index J'
    assert_text 'Jena'
  end

  test 'Show the chronology' do
    visit project_url
    find('.dfk-square-arrow', text: 'Chronologie der Ausstellungen').click
    assert_text 'Sakrale Kunst'

    find('or-list-item', text: 'Sakrale Kunst').click
    assert_text 'Baden-Baden' # a keyword
  end
end
