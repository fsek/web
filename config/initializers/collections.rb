# encoding: UTF-8
# Tanken är att man kan spara listor här
class Collections
  def self.up
    if(List.where(:name => 'Styrelse').take == nil)
      List.create(:name => 'Styrelse',:category => 'kontakt',:string1 => 'styrelse@fsektionen.se')
    end
    if(List.where(:name => 'Ordförande').take == nil)
      List.create(:name => 'Ordförande',:category => 'kontakt',:string1 => 'ordf@fsektionen.se')
    end
    if(List.where(:name => 'Cafémästeriet').take == nil)
      List.create(:name => 'Cafémästeriet',:category => 'kontakt',:string1 => 'cafe@fsektionen.se')
    end
    if(List.where(:name => 'Överfös').take == nil)
      List.create(:name => 'Överfös',:category => 'kontakt',:string1 => 'overfos@fsektionen.se')
    end
    if(List.where(:name => 'Kulturministeriet').take == nil)
      List.create(:name => 'Kulturministeriet',:category => 'kontakt',:string1 => 'kultur@fsektionen.se')
    end
    if(List.where(:name => 'Näringslivsutskottet').take == nil)
      List.create(:name => 'Näringslivsutskottet',:category => 'kontakt',:string1 => 'fnu@fsektionen.se')
    end
    if(List.where(:name => 'Prylmästeriet').take == nil)
      List.create(:name => 'Prylmästeriet',:category => 'kontakt',:string1 => 'prylm@fsektionen.se')
    end
    if(List.where(:name => 'Sanningsministeriet').take == nil)
      List.create(:name => 'Sanningsministeriet',:category => 'kontakt',:string1 => 'sanning@fsektionen.se')
    end
    if(List.where(:name => 'Sexmästeriet').take == nil)
      List.create(:name => 'Sexmästeriet',:category => 'kontakt',:string1 => 'sex@fsektionen.se')
    end
    if(List.where(:name => 'Utbildningsminister').take == nil)
      List.create(:name => 'Utbildningsminister',:category => 'kontakt',:string1 => 'um@fsektionen.se')
    end
    if(List.where(:name => 'Vice ordförande').take == nil)
      List.create(:name => 'Vice ordförande',:category => 'kontakt',:string1 => 'viceordf@fsektionen.se')
    end
    if(List.where(:name => 'Kassör').take == nil)
      List.create(:name => 'Kassör',:category => 'kontakt',:string1 => 'kass@fsektionen.se')
    end
    if(List.where(:name => 'Sekreterare').take == nil)
      List.create(:name => 'Sekreterare',:category => 'kontakt',:string1 => 'sekreterare@fsektionen.se')
    end
    if(List.where(:name => 'Spindelmän').take == nil)
      List.create(:name => 'Spindelmän',:category => 'kontakt',:string1 => 'spindelman@fsektionen.se')
    end
    if(List.where(:name => 'Likabehandlingsombud').take == nil)
      List.create(:name => 'Likabehandlingsombud',:category => 'kontakt',:string1 => 'libo@fsektionen.se')
    end
  end
  def self.bildkategori
    @@bildkategori ||= # Execute the SQL query to populate the array here.
    @@bildkategori = ['Nollning','Fetsm']
  end
  def self.kontaktlista
    @@kontaktlista ||= # Execute the SQL query to populate the array here.
    @@kontaktlista = ["Styrelse","Ordförande","Vice ordförande","Kassör","Spindelmän","Sanningsministeriet","Näringslivsutskottet","Likabehandlingsombud"]
  end

  def self.bildkategoriadd element
    if @@bildkategori
      @@bildkategori << element
    else
      @@bildkategori = [element]
    end
  end
  def self.bildkategorichange elementRm, elementAdd
    if @@bildkategori
      @@bildkategori = @@bildkategori-[elementRm]
      @@bildkategori << elementAdd
    else
      @@bildkategori = [elementAdd]
    end
  end
  def self.bildkategoriremove element
    if @@bildkategori
      @@bildkategori = @@bildkategori-[element]      
    end
  end
end