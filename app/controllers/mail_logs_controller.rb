class MailLogsController < ApplicationController
  before_action :set_mail_log, only: %i[ show destroy ]
  before_action :is_user_authorized?

  # GET /mail_logs or /mail_logs.json
  def index
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"], 'api.eu.mailgun.net'
    domain = ENV["MAILGUN_DOMAIN"]
    @result_failed = mg_client.get("#{domain}/events", {:event => 'failed'}).to_h
    @result_opened = {}.to_h

    @mail_logs = current_user.mail_logs
    unless params[:to].blank?
      @mail_logs = @mail_logs.where("LOWER(mail_logs.to) like :search", {search: "%#{params[:to]}%".downcase})
    end

    unless params[:search_subject].blank?
      @mail_logs = @mail_logs.where(subject: params[:search_subject])
    end

    if params[:ko].blank?
      @result_opened = mg_client.get("#{domain}/events", {:event => 'opened'}).to_h
    end
  end

  # GET /mail_logs/1 or /mail_logs/1.json
  def show
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"], 'api.eu.mailgun.net'
    domain = ENV["MAILGUN_DOMAIN"]
    @result = mg_client.get("#{domain}/events", {:event => 'failed'}).to_h
    @result_opened = mg_client.get("#{domain}/events", {:event => 'opened'}).to_h
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_log
      @mail_log = MailLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mail_log_params
      params.require(:mail_log).permit(:to, :subject, :message_id, :user_id)
    end

    def is_user_authorized?
      authorize @mail_log ? @mail_log : MailLog
    end
end
