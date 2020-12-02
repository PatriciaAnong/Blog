from aws_cdk import (
  core,
  aws_cloudwatch as cw,
  aws_ec2 as ec2,
  aws_sns as sns,
  aws_events as events,
  aws_sns_subscriptions as subscriptions,
  aws_cloudwatch_actions as cw_actions,
)

from aws_cdk.core import App, Construct, Stack

nova = core.Environment(account="000000000000", region="us-east-1")
ohio = core.Environment(region="us-east-2")

class AutomationRocksStack(core.Stack):

    def __init__(self, scope: core.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # The code that defines your stack goes here

        sns_topic = sns.Topic(self, 'Topic')

        snsEmail = core.CfnParameter(self,
                                      'SNSEmail',
                                      default = 'PAnong@automation_rocks.com',
                                      description = 'Email Endpoint for SNS Notifications',
                                      type = 'String'
                                      )

        email = sns_topic.add_subscription(subscriptions.EmailSubscription(
                                                                snsEmail.value_as_string
                                                            )
                                      )

        cwAlarm = cw.CfnAlarm(self, 'VPCAlarm',
              actions_enabled=True,
              alarm_actions=[sns_topic.topic_arn],
              alarm_description="A CloudWatch Alarm that triggers when changes are made to the VPC.",
              comparison_operator="GreaterThanOrEqualToThreshold",
              evaluation_periods=1,
              treat_missing_data="notBreaching",
              threshold=1,
              metric_name="VpcEventCount",
              namespace="CloudTrailMetrics",
              period=300,
              statistic="Sum",
        )
