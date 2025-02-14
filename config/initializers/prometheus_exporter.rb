# config/initializers/prometheus.rb
unless Rails.env.test?
    require 'prometheus_exporter/middleware'
    require 'prometheus_exporter/instrumentation'
  
    # Add basic request metrics middleware
    Rails.application.middleware.unshift PrometheusExporter::Middleware
  
    # Start process instrumentation for basic stats like RSS and GC
    PrometheusExporter::Instrumentation::Process.start(type: "web")
  end
  