pool_size = 25
REDIS = ConnectionPool.new(size: pool_size) do
  Redis.new
end
