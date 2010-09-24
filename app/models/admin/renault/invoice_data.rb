class Admin::Renault::InvoiceData < ActiveRecord::Base
  set_table_name "admin_renault_invoice_datas"
  belongs_to :invoice_excel
  
  #  cattr_reader :per_page
  #  @@per_page = 30
  #named_scope :invoices, lambda { |a|  { :conditions => [ 'NROCTEDESS = ?', a ] }  }
 
  named_scope :segment, lambda { |a| { :conditions => [ 'CODSEG = ?', a ] } }
  named_scope :segments, lambda { |a, b| { :conditions => [ 'CODSEG = ? OR CODSEG =? ', a , b] } }
  named_scope :facture, lambda { |a| { :conditions => [ 'CODFAC = ?', a ] } }
  named_scope :codfam, lambda { |a| { :conditions => [ 'CODFAM = ?', a ] } }

   #  named_scope :fac_sum,   :conditions => [ 'CODFAC IN(13,16)' ]
   #  named_scope :fac_sub,   :conditions => [ 'CODFAC IN(23,26)']

  #named_scope :local,  :conditions => [ 'CODCON IN(1,4,7)']
  named_scope :local,  :conditions => [ 'CODFAC IN(1,4,7)']
  named_scope :for_month, lambda { |a| { :conditions => [ 'MONTH(DATCRE) =<?', a ] } }

  named_scope :year, lambda { |a| { :conditions => [ 'YEAR(DATCRE) =?', a ] } }
  named_scope :monthly, :select => 'MONTHNAME(DATCRE) AS month, SUM(sumOfPCLTOT) AS retail_to, SUM(sumOfPNCTOT) AS  dealer_net_to', :group => 'MONTH(DATCRE)'
  named_scope :stock_monthly, lambda { |a| { :select => 'SUM(sumOfPNCTOT) AS  stock_purchase',  :conditions => [ 'MONTHNAME(DATCRE) = ? AND CODFAC = 16'  , a ] } }

  #  named_scope :until_month, lambda { |a| { :conditions => [ 'MONTH(DATCRE) >=?', a ] } }
  #  named_scope :interval, lambda { |a| { :conditions => [ 'DATE_SUB(CURDATE(),INTERVAL ? MONTH) <= DATCRE ', a ] } }

  named_scope :interval_for, lambda { |a, b| { :conditions => [ 'DATCRE >= ? AND DATCRE < ?    ', a, b  ] } }

  named_scope :in, lambda { |a| { :conditions => [ 'NROCTEDESS IN(?) ', a  ] }}


  named_scope :am, :conditions => [ 'CODFAM IN(170, 286, 287, 288, 321, 332,336,
339, 370, 475, 479, 704, 705, 707,
708, 709, 710, 781, 782, 817, 818,
837, 838, 904, 905, 907, 908, 909,
911, 913, 914, 924, 928, 943, 944,
946, 949, 965, 966, 968, 982, 342, 511, 897, 898, 917, 959, 962) AND CODSEG IN("A","L")' ]
  named_scope :oe, :conditions => [ 'CODFAM IN(002, 009, 030, 032, 069, 085,
145, 208, 241, 243, 485, 486, 500,
505, 508, 519, 522, 525, 538, 541,
545, 549, 550, 561, 562, 563, 565,
567, 578, 584, 611, 655, 656, 033,
034, 035, 036, 042, 060, 112, 113,
114, 116, 117, 118, 122, 124, 135,
496, 528, 532, 601, 602, 603, 607,
609, 610, 615, 631, 635, 660, 663,
664, 722, 725, 728, 772, 803, 804,
805, 806, 807, 811, 812, 813, 814,
820, 821, 822, 823, 824, 827, 835,
926, 942, 972, 977, 200, 201, 202,
205, 282, 284, 462, 463, 466, 632,
633, 634, 851, 855, 856, 857, 861,
864, 890, 901, 151, 193, 352, 488,
501, 502, 503, 506, 507, 513, 520,
554, 581, 658, 673, 674, 892, 960, 961, 988, 197, 801, 802, 964) AND CODSEG IN("M","R","U","C","E","P")' ]


end

# WHERE MONTH(DATCRE) BETWEEN '4' AND '7'  AND (NROCTEDESS IN(22110) ) AND YEAR(DATCRE) = 2009
