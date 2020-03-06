pipeline{
	agent any;
	environment {
		TMPDIR='$WORKSPACE/.cpptesttmp'
	}	
	stages {
		stage('Check out') {
			steps {
				checkout scm
			}
		}
		stage('create docker container') {
			steps {
				sh label: '', script: '''
					docker run \\
					--name atm_build \\
					--workdir=$WORKSPACE/ATM \\
					-itd \\
					-v $WORKSPACE:$WORKSPACE \\
					-v /opt/app/parasoft:/opt/app/parasoft \\
					stronglytyped/arm-none-eabi-gcc'''
			}
		}
		stage('Build & Create Build Data File') {
			steps {
				sh label: '', script: '''
					docker exec \\
					--workdir=$WORKSPACE/ATM \\
					atm_build \\
					/opt/app/parasoft/cpptest/10.4/cpptesttrace \\
					--cpptesttraceOutputFile=$WORKSPACE/ATM/cpptestscan.bdf \\
					--cpptesttraceProjectName=ATM \\
					--cpptesttraceTraceCommand=arm-none-eabi-gcc\\|arm-none-eabi-g++ \\
					./build.sh'''
			}
		}
		stage('Import C++test Project form BDF') {
			steps {
				sh label: '', script: '''
					/opt/app/parasoft/cpptest/10.4/cpptestcli \\
					-data $WORKSPACE/cpptest_workspace \\
					-bdf $WORKSPACE/ATM/cpptestscan.bdf \\
					-localsettings $WORKSPACE/../tools/atm_build/local_settings/import.properties'''
			}
		}
		stage('Run Statick analysis') {
			steps {
				    sh label: '', script: '''
					/opt/app/parasoft/cpptest/10.4/cpptestcli \\
					-data $WORKSPACE/cpptest_workspace \\
					-config "builtin://MISRA C 2012" \\
					-localsettings $WORKSPACE/../tools/atm_build/local_settings/import.properties \\
					-report reports \\
					-resource ATM \\
					-showdetails \\
					-appconsole stdout'''
			}
		}
		stage('Run Metrics analysis') {
			steps {
				sleep 2
			}
		}
		stage('Delete docker container') {
			steps {
				sh label: '', script: '''
				docker stop atm_build
				docker rm atm_build
				'''
			}
		}
	}
}

