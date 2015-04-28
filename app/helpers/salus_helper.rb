module SalusHelper
  def rotation_xml_for(component)
    logger.info "current #{component}"
    case component[:type]
    when 'harvest'
        "<Mgt_Harvest_App Year='#{component[:year]}' DOY='#{component[:doy]}' DAP='' HStg='' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' url='#{component[:url]}' notes='#{component[:notes]}'/ >\n"
    when 'planting'
        "<Mgt_Planting CropMod='S' SpeciesID='#{component[:species]}' CultivarID='' Year='#{component[:year]}' DOY='#{component[:doy]}' EYear='0' EDOY='' Ppop='#{component[:ppop]}' Ppoe='' PlMe='S' PlDs='' RowSpc='' AziR='' SDepth='' SdWtPl='' SdAge='' ATemp='' PlPH='' url='#{component[:url]}' notes='#{component[:notes]}' />\n"
    when 'tillage'
      "<Mgt_Tillage_App Year='#{component[:year]}' DOY='#{component[:doy]}' url='#{component[:url]}' notes='#{component[:notes]}'/>\n"
    when 'fertilizer'
        "<Mgt_Fertilizer_App DSoilN='10' SoilNC='95' SoilNX='50' NCode='#{component[:fertilizer]}' NEnd='4' url='#{component[:url]}' notes='#{component[:notes]}'/>\n"
    when 'irrigation'
  
    end
  end
end
