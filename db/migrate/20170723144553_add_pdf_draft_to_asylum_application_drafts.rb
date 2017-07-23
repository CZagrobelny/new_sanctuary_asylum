class AddPdfDraftToAsylumApplicationDrafts < ActiveRecord::Migration[5.0]
  def change
    add_column :asylum_application_drafts, :pdf_draft, :string
  end
end
