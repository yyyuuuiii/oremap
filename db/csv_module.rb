require "csv"

module CsvModule

	DEFAULT_ENCODING = "utf-8"
	DEFAULT_SEED_PATH = "./db/"

	@@encoding = DEFAULT_ENCODING
	@@seed_path = DEFAULT_SEED_PATH
	@@table_name = nil
	@@model = nil

	def self.import(table_name, before_options = {}, after_options = {}, import_options = {})
		@@table_name = table_name
		@@model = table_name.classify.constantize
		@@encoding = import_options[:encoding] || DEFAULT_ENCODING

		exec_options(before_options, :BEFORE) if before_options.present?

		import_all

		exec_options(after_options, :AFTER) if after_options.present?
	end

	def self.exec_options(options, timing)
		options.each do |option, value|
			case option
			when :truncate
				next unless value
				sql = "TRUNCATE TABLE " + @@table_name + ";"
				ActiveRecord::Base.connection.execute(sql)
				msg = "全てのレコードを削除:"+sql
			when :delete_all
				next unless value
				@@model.delete_all
				msg = "全てのレコードを削除"
			when :delete_before
				@@model.delete_all(["id <= " + value.to_s])
				msg = "ID#{value}以下のレコードを削除"
			else
				raise "[#{@@table_name}]#{timing} : 存在しないオプション #{option}"
			end

			puts "[#{@@table_name}]#{timing} : #{msg}"
		end
	end
	private_class_method :exec_options

	def self.import_all
		rows, fields = retrieve_rows_and_fields_from_csv

		rows.each do |row|
			next if row[0].blank?
			record = @@model.find_or_initialize_by_id(row[0])
			fields.each_with_index do |field, i|
				next if field.blank?
				record.send(field + "=", row[i])
			end
			record.save!
		end

		puts "[#{@@table_name}]Import : #{rows.size} records"
	end
	private_class_method :import_all

	def self.retrieve_rows_and_fields_from_csv
		rows = CSV.read(@@seed_path + @@table_name + ".csv", encoding: @@encoding)
		fields = rows.shift

		return [rows, fields]
	end
	private_class_method :retrieve_rows_and_fields_from_csv
end