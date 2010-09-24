
class OutletDrawer



   def self.draw(outlet)

      pdf = PDF::Writer.new

      pdf.text outlet.id.to_s

      pdf.render
   end

end