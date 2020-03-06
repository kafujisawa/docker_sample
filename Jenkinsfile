pipeline{
	agent any;
	environment {
		TMPDIR=$WORKSPACE/.cpptesttmp
		CONTAINAR_NAME=atm_build
		CPPTEST_INS_DIR=/opt/app/parasoft/cpptest/10.4
		CPPTEST_SCAN_PROJECT_NAME=ATM
		CPPTEST_SCAN_OUTPUT_FILE=$WORKSPACE/$CPPTEST_SCAN_PROJECT_NAME/cpptestscan.bdf
		CPPTEST_SCAN_TRACECOMMAND=arm-none-eabi-gcc\|arm-none-eabi-g++
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
					--name $CONTAINAR_NAME \\
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
					$CONTAINAR_NAME \\
					$CPPTEST_INS_DIR/cpptesttrace \\
					./build.sh'''
			}
		}
		stage('Import C++test Project form BDF') {
			steps {
				sh label: '', script: '''
					$CPPTEST_INS_DIR/cpptestcli \\
					-data $WORKSPACE/cpptest_workspace \\
					-bdf $WORKSPACE/ATM/cpptestscan.bdf \\
					-localsettings $WORKSPACE/../tools/$CONTAINAR_NAME/local_settings/import.properties'''
			}
		}
		stage('Run Statick analysis') {
			steps {
				    sh label: '', script: '''
					$CPPTEST_INS_DIR/cpptestcli \\
					-data $WORKSPACE/cpptest_workspace \\
					-config "builtin://MISRA C 2012" \\
					-localsettings $WORKSPACE/../tools/$CONTAINAR_NAME/local_settings/import.properties \\
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
				docker stop $CONTAINAR_NAME
				docker rm $CONTAINAR_NAME
				'''
			}
		}
	}
}

