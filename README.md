# ActiveModel::Password

`ActiveModel::Password` is a lightweight password model implemented
on top of `ActiveModel::Model`.

## Installation

Add this line to your application's Gemfile:

    gem "active_model-password"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model-password

## Usage

The most popular workflow is:

    class PasswordsController < ApplicationController
      def edit
        @password = ActiveModel::Password.new
        @password.user = current_user
      end

      def update
        @password = ActiveModel::Password.new(password_params)
        @password.user = current_user
        if @password.save
          redirect_to root_url, notice: "Password changed successfully."
        else
          render :edit
        end
      end

      private

      def password_params
        params.require(:active_model_password).permit(:password, :password_confirmation)
      end
    end

If you don't like the default behavior, you can always inherit the
password model and override some defaults:

     class Password < ActiveModel::Password
       validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./}, length: {in: 8..255}, if: -> { password.present? }
     end


## Copyright

Copyright © 2014 Kuba Kuźma. See LICENSE for details.
