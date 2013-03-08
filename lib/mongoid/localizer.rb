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
        object[locale.to_s]
      end
    end
  end
end
