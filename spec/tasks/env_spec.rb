require 'spec_helper'

describe Recap::Tasks::Env do
  let :config do
    Capistrano::Configuration.new
  end

  let :namespace do
    config.env
  end

  before do
    Recap::Tasks::Env.load_into(config)
  end

  describe 'Settings' do
    describe '#environment_file' do
      it 'defaults to /home/ + application_user + /.env' do
        config.set :application_user, 'marigold'
        config.environment_file.should eql('/home/marigold/.env')
      end
    end
  end

  describe 'Tasks' do
    before do
      config.set :environment_file, 'path/to/.env'
      namespace.stubs(:deployed_file_exists?).with(config.environment_file, '.').returns(true)
      namespace.stubs(:capture).with("cat #{config.environment_file}").returns('')
      namespace.stubs(:puts)
    end

    describe 'env' do
      it 'outputs the current environment if one exists' do
        namespace.stubs(:capture).with("cat #{config.environment_file}").returns("A=b\nX=Y")
        namespace.expects(:puts).with('The config variables are:')
        namespace.expects(:puts).with(responds_with(:to_s, Recap::Support::Environment.from_string("A=b\nX=Y").to_s))
        config.find_and_execute_task('env')
      end
    end

    describe 'env:set' do
      it 'merges the edited environment with the default one' do
        config.set_default_env 'A', 'b'
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string("A=b\nX=Y").to_s, config.environment_file)
        namespace.stubs(:env_argv).returns(['X=Y'])
        config.find_and_execute_task('env:set')
      end

      it 'allows overriding of the default environment' do
        config.set_default_env 'A', 'b'
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string('A=c').to_s, config.environment_file)
        namespace.stubs(:env_argv).returns(['A=c'])
        config.find_and_execute_task('env:set')
      end

      it 'can unset a variable by assigning an empty value to it' do
        namespace.stubs(:capture).with("cat #{config.environment_file}").returns("X=Y\nA=b")
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string('X=Y').to_s, config.environment_file)
        namespace.stubs(:env_argv).returns(['A='])
        config.find_and_execute_task('env:set')
      end

      it 'uploads the new environment' do
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string('X=Y').to_s, config.environment_file)
        namespace.stubs(:env_argv).returns(['X=Y'])
        config.find_and_execute_task('env:set')
      end

      it 'removes the environment if it is empty' do
        namespace.stubs(:capture).with("cat #{config.environment_file}").returns("X=Y")
        namespace.expects(:as_app).with("rm -f #{config.environment_file}", '~')
        namespace.stubs(:env_argv).returns(['X='])
        config.find_and_execute_task('env:set')
      end
    end

    describe 'env:reset' do
      it 'removes the environment file from the server' do
        namespace.stubs(:env_argv).returns([])
        namespace.expects(:as_app).with("rm -f #{config.environment_file}", '~').at_least_once
        config.find_and_execute_task('env:reset')
      end
    end

    describe 'env:edit' do
      it 'merges the edited environment with the default one' do
        config.set_default_env 'A', 'b'
        namespace.stubs(:edit_file).returns('X=Y')
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string("A=b\nX=Y").to_s, config.environment_file)
        config.find_and_execute_task('env:edit')
      end

      it 'allows overriding of the default environment' do
        config.set_default_env 'A', 'b'
        namespace.stubs(:edit_file).returns('A=c')
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string('A=c').to_s, config.environment_file)
        config.find_and_execute_task('env:edit')
      end

      it 'uploads the new environment' do
        namespace.stubs(:edit_file).returns('X=Y')
        namespace.expects(:put_as_app).with(Recap::Support::Environment.from_string('X=Y').to_s, config.environment_file)
        config.find_and_execute_task('env:edit')
      end

      it 'removes the environment if it is empty' do
        namespace.stubs(:edit_file).returns('')
        namespace.expects(:as_app).with("rm -f #{config.environment_file}", '~')
        config.find_and_execute_task('env:edit')
      end
    end
  end
end