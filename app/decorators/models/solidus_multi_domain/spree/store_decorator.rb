# frozen_string_literal: true

module SolidusMultiDomain
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.class_eval do
          has_and_belongs_to_many :products, join_table: 'spree_products_stores'
          has_many :taxonomies
          has_many :orders

          has_many :store_shipping_methods
          has_many :shipping_methods, through: :store_shipping_methods

          has_and_belongs_to_many :promotion_rules, class_name: 'Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'

          has_attached_file :logo,
            styles: { mini: '48x48>', small: '100x100>', medium: '250x250>' },
            default_style: :medium,
            url: '/spree/stores/:id/:style/:basename.:extension',
            path: ':rails_root/public/spree/stores/:id/:style/:basename.:extension',
            convert_options: { all: '-strip -auto-orient' }

          validates_attachment_content_type :logo,
            presence: true,
            content_type: %w[image/jpeg
                             image/jpg
                             image/gif
                             image/png]
          def logo_original
            return logo.url unless logo.nil?
          end

          def logo_mini
            return logo.url(:mini) unless logo.nil?
          end

          def logo_small
            return logo.url(:small) unless logo.nil?
          end

          def logo_medium
            return logo.url(:medium) unless logo.nil?
          end
        end
      end

      ::Spree::Store.prepend self
    end
  end
end