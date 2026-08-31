# config/initializers/yaml_permitted_classes.rb

# Permite que o ActiveRecord (e o PaperTrail) desserialize classes comuns sem disparar Psych::DisallowedClass
Rails.application.config.active_record.yaml_column_permitted_classes ||= []
Rails.application.config.active_record.yaml_column_permitted_classes += [
  Symbol,
  Date,
  Time,
  ActiveSupport::TimeWithZone,
  ActiveSupport::TimeZone,
  BigDecimal
]