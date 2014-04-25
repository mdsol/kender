module Kender
  class I18nVerify < Command
    def available?
      Gem::Specification::find_all_by_name('i18n-tasks').any?
    end

    # The commands missing and unused produce informational reports only.
    def command
      'i18n-tasks missing; i18n-tasks unused'
    end
  end
end