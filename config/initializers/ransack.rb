# app/config/initializers/ransack.rb

Ransack.configure do |config|
  config.add_predicate 'contains',
    arel_predicate: 'contains',
    formatter: proc { |v| "{#{v}}" },
    validator: proc { |v| v.present? },
    type: :string
end