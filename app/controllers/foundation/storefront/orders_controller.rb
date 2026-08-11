# frozen_string_literal: true

module Foundation
  module Storefront
    class OrdersController < BaseController
      before_action :authenticate_user!, only: :index

      def index
        @orders = current_user.storefront_orders.includes(:line_items)
          .order(created_at: :desc)
          .limit(50)
      end

      def show
        @order = Order.includes(:line_items).find_by!(public_reference: params[:id])
        head :not_found unless ReceiptAccess.allowed?(order: @order, user: current_user, token: params[:access_token])
      end
    end
  end
end
