module MyApplicationTomiuk
  module ItemContainer
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module ClassMethods
      def class_info
        "Class: #{name}, version 1.0"
      end

      def object_count
        @object_count ||= 0
      end

      def increment_object_count
        @object_count ||= 0
        @object_count += 1
      end
    end

    module InstanceMethods
      def add_item(item)
        items << item
        MyApplicationTomiuk::LoggerManager.log_processed_file("Item added: #{item.name}")
      end

      def remove_item(item)
        items.delete(item)
        MyApplicationTomiuk::LoggerManager.log_processed_file("Item removed: #{item.name}")
      end

      def delete_items
        items.clear
        MyApplicationTomiuk::LoggerManager.log_processed_file('All items removed')
      end

      def method_missing(method, *args, &)
        if method == :show_all_items
          items.each { |i| puts i }
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        method == :show_all_items || super
      end
    end
  end
end
