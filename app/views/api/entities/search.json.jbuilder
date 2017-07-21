json.aggregations do
  json.people do
    @result["aggregations"].each do |k, v|
      json.set! k.split('.').last, v if k.match(/^people/)
    end
  end
  json.attribs do
    @result["aggregations"].each do |k, v|
      json.set! k.split('.').last, v if k.match(/^attribs/)
    end
  end
  json.journals @result['aggregations']['journals']
  json.type @result['aggregations']['type']
  json.year_ranges @result['aggregations']['year_ranges']
  json.register @result['aggregations']['register']
end
json.total @result["hits"]["total"]
json.records @result["hits"]["hits"]
json.page params[:page] || 1
json.per_page params[:per_page] || 10
