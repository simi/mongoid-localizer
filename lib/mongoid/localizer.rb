require 'mongoid'
require 'i18n'

module Mongoid
  class Localizer
    class << self
      def locale
        read_locale || I18n.locale
      end

      def locale=(locale)
        set_locale(locale)
      end

      def with_locale(locale, &block)
        previous_locale = read_locale
        set_locale(locale)
        result = yield(locale)
        set_locale(previous_locale)
        result
      end

      protected

      def set_locale(locale)
        Thread.current[:mongoid_locale] = locale.try(:to_sym)
      end

      def read_locale
        Thread.current[:mongoid_locale]
      end
    end
  end
end

module Mongoid
  module Fields
    class Localized < Standard
      # Convert the provided string into a hash for the locale.
      # @example Serialize the value.
      #   field.mongoize("testing")
      #
      # @param [ String ] object The string to convert.
      #
      # @return [ Hash ] The locale with string translation.
      #
      # @since 2.3.0
      def mongoize(object)
        { Mongoid::Localizer.locale.to_s => type.mongoize(object) }
      end

      private

      # Lookup the value from the provided object.
      #
      # @api private
      #
      # @example Lookup the value.
      #   field.lookup({ "en" => "test" })
      #
      # @param [ Hash ] object The localized object.
      #
      # @return [ Object ] The object for the locale.
      #
      # @since 3.0.0
      def lookup(object)
        locale = Mongoid::Localizer.locale
        if ::I18n.respond_to?(:fallbacks)
          if options[:localize].is_a?(Hash) and options[:localize][:prevent_fallback]
            object[locale.to_s]
          else
            object[::I18n.fallbacks[locale].map(&:to_s).find{ |loc| object[loc] }]
          end
        else
          object[locale.to_s]
        end
      end
    end
  end
end

# encoding: utf-8
module Origin
  # This is a smart hash for use with options and selectors.
  class Smash < Hash
    private
    # Get the normalized value for the key. If localization is in play the
    # current locale will be appended to the key in MongoDB dot notation.
    #
    # @api private
    #
    # @example Get the normalized key name.
    #   smash.normalized_key("field", serializer)
    #
    # @param [ String ] name The name of the field.
    # @param [ Object ] serializer The optional field serializer.
    #
    # @return [ String ] The normalized key.
    #
    # @since 1.0.0
    def normalized_key(name, serializer)
      serializer && serializer.localized? ? "#{name}.#{::Mongoid::Localizer.locale}" : name
    end
  end
end
