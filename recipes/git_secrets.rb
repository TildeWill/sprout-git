include_recipe 'sprout-git::git_hooks'

git_hooks_global_dir = node['sprout']['git']['git_hooks']['global_dir']

package 'git-secrets'

execute 'git secrets --register-aws --global' do
  returns [0, 1]
end

hooks = [
  'pre-commit',
  'commit-msg',
  'prepare-commit-msg'
]

hooks.each do |hook|
  directory "#{git_hooks_global_dir}/#{hook}" do
    mode 0755
    owner node['sprout']['user']
  end
  template "#{git_hooks_global_dir}/#{hook}/00-git-secrets" do
    mode 0755
    owner node['sprout']['user']
    source '00-git-secrets.erb'
    variables hook_name: "#{hook.tr('-', '_')}_hook"
  end
end
