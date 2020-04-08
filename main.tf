locals {
  name_prefix = "[${var.service_name}][${var.environment}][${var.region}]"
  tags        = ["service_name:${var.service_name}"]
}

resource "datadog_monitor" "container_flapping" {
  name  = "${local.name_prefix} '{{kube_container_name}}' container restarting in '{{pod_name}}'"
  type  = "metric alert"
  query = "change(max(last_5m),last_5m):max:kubernetes.containers.restarts{service_name:${var.service_name}} by {service_name,pod_name,kube_container_name,kube_namespace} > ${var.restarts_critical_threshold}"

  message = <<-EOF
  {{#is_alert}}
  The {{kube_container_name}} container in {{pod_name}} has been restarted {{value}} times in the last 5 minutes.

  {{/is_alert}}
  {{#is_recovery}}
  The {{kube_container_name}} container in {{pod_name}} is stable. No restarts in the last 5 minutes.
  {{/is_recovery}}

  ${var.notification_targets}
  EOF

  include_tags = false

  thresholds = {
    ok                = 0
    critical          = var.restarts_critical_threshold
    critical_recovery = 0
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false

  tags = local.tags
}
