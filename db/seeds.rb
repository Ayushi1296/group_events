# frozen_string_literal: true

if User.count.zero?
  User.create!(
    name: 'test user',
    email: 'test@email.com'
  )
end
