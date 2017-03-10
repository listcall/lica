# integration_test: features/admin/svc_reps

class Rep::TemplateUtil
  class << self
    def new(name: nil)
      fetch(name)
    end

    def fetch(id)
      db_klas.fetch(id) || fs_klas.fetch(id)
    end

    def all
      fs_klas.all + db_klas.all
    end

    private

    def db_klas; Rep::TemplateDb; end
    def fs_klas; Rep::TemplateFs; end
  end
end