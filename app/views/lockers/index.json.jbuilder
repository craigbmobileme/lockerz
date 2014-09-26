json.array!(@lockers) do |locker|
  json.extract! locker, :id
  json.url locker_url(locker, format: :json)
end
