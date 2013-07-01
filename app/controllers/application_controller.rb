class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :disable_session_cookies

  def translations
    # This is necessary so the translation files are loaded
    I18n.t('trade')
    locales = I18n.backend.send(:translations)
    @translations = {}
    locales.each do |locale, all|
      @translations[locale] = all[:gedviz]
    end
  end

  private

  def set_locale
    I18n.locale = get_locale
  end

  def get_locale
    forced = params[:lang].try(:to_sym)
    default = I18n.default_locale
    available = I18n.available_locales
    return forced if forced.present? and available.include?(forced)
    request.compatible_language_from(available) || default
  end

  def disable_session_cookies
    request.session_options[:skip] = true
  end

end
