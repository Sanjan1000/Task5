class UsersController < ApplicationController
  require 'faker'

  def index
    @region = params[:region]
    @error_rate = params[:error_rate].to_f
    @seed = params[:seed].to_i
    per_page = params[:per_page] || 10  
    page = params[:page] || 1
    
    @users = UserGenerator.generate_users(@region, @error_rate, @seed, per_page.to_i, (page.to_i - 1) * per_page.to_i + 1)
    
    respond_to do |format|
      format.html
      format.js { render partial: 'users', locals: { users: @users } }
    end
  end
end

class UserGenerator
  def self.generate_users(region, error_rate, seed, batch_size, start_index = 1)
    Faker::Config.random = Random.new(seed)

    users = []
    batch_size.times do
      users << generate_user(region, error_rate, start_index)
      start_index += 1
    end
    users
  end

  def self.generate_user(region, error_rate, index)
    identifier = Faker::Alphanumeric.alphanumeric(number: 10)

 
    name, address, phone = generate_user_details(region)
    com=error_rate/100
    if error_rate > 0||com < error_rate
      name, address, phone = introduce_errors(name, address, phone)
    end

    OpenStruct.new(index: index, identifier: identifier, name: name, address: address, phone: phone)
  end

  private_class_method def self.generate_user_details(region)
    name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
    address = "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.zip_code}"
    phone = "+#{Faker::PhoneNumber.phone_number}"

    case region
    when 'USA'
      name = "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
      address = "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
      phone = "+1 #{Faker::PhoneNumber.phone_number}"
    when 'Poland'
      phone = "+48 #{Faker::PhoneNumber.phone_number}"
    when 'Georgia'
      phone = "+995 #{Faker::PhoneNumber.phone_number}"
    end

    [name, address, phone]
  end

  private_class_method def self.introduce_errors(name, address, phone)
    field = %i[name address phone].sample
    case field
    when :name
      name = Faker::Name.unique.name
    when :address
      address = Faker::Address.unique.full_address
    when :phone
      phone = Faker::PhoneNumber.unique.phone_number
    end

    [name, address, phone]
  end
end
  def self.introduce_errors(name, address, phone)
    field = %i[name address phone].sample
    case field
    when :name
      name = Faker::Name.unique.name
    when :address
      address = Faker::Address.unique.full_address
    when :phone
      phone = Faker::PhoneNumber.unique.phone_number
    end
    [name, address, phone]
  end

  def self.generate_name(region)
    case region
    when 'Poland', 'Georgia'
      "#{Faker::Name.first_name} #{Faker::Name.last_name}"
    when 'USA'
      "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
    end
  end

  def self.generate_address(region)
    case region
    when 'Poland'
      "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.zip_code}"
    when 'USA'
      "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
    when 'Georgia'
      "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.country}"
    end
  end

  def self.generate_phone(region)
    case region
    when 'Poland'
      "+48 #{Faker::PhoneNumber.phone_number}"
    when 'USA'
      "+1 #{Faker::PhoneNumber.phone_number}"
    when 'Georgia'
      "+995 #{Faker::PhoneNumber.phone_number}"
    end

    if error_rate > 0
      if rand < error_rate
        field = %i[name address phone].sample
        case field
        when :name
          name = Faker::Name.unique.name
        when :address
          address = Faker::Address.unique.full_address
        when :phone
          phone = Faker::PhoneNumber.unique.phone_number
        end
      end
    end
    OpenStruct.new(index: index, identifier: identifier, name: name, address: address, phone: phone)
  end
  def self.generate_users(region, error_rate, seed, batch_size)
    users = []
    batch_size.times do
      users << generate_user(region, error_rate, seed)
    end
    users
  end