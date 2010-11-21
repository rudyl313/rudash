include_recipe "postgresql::server"

execute "create-db-user-#{node[:pg][:user]}" do
  command "psql -c '\\du' | grep -q '#{node[:pg][:user]}' || psql -c \"create user #{node[:pg][:user]} with createdb login encrypted password \'#{node[:pg][:user]}'\""
  action :run
  user 'postgres'
end

# Don't include the test database
node[:pg][:databases].each do |db_name|
  execute "create-db-#{db_name}" do
    command "psql -c '\\l' | grep -q '#{db_name}' || createdb #{db_name}"
    action :run
    user 'postgres'
  end

  execute "grant-perms-on-#{db_name}-to-#{node[:pg][:user]}" do
    command "/usr/bin/psql -c 'grant all on database #{db_name} to #{node[:pg][:user]}'"
    action :run
    user 'postgres'
  end

  execute "alter-public-schema-owner-on-#{db_name}-to-#{node[:pg][:user]}" do
    command "/usr/bin/psql #{db_name} -c 'ALTER SCHEMA public OWNER TO #{node[:pg][:user]}'"
    action :run
    user 'postgres'
  end
end
