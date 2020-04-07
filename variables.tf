variable "service_name" {
  type        = string
  description = "The service_name as set in Pod labels to apply monitors on"
}

variable "environment" {
  type        = string
  description = "The environment the monitors are being applied to. Used to name the monitor."
}

variable "region" {
  type        = string
  description = "The region the monitors are being applied to. Used to name the monitor."
}

variable "restarts_critical_threshold" {
  type        = number
  default     = 2
  description = "(Optional) The number of restarts of a given container in a 5-minute window required to trigger an alert."
}

variable "notification_targets" {
  type        = list(string)
  description = "List of targets to notify. Slack channels must be configured in DataDog previously. (Ex: @jdharrington@instructure.com, @slack-bx-core-notif)"
}
