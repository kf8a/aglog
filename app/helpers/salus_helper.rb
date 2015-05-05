module SalusHelper
  def rotation_xml_for(component)
    logger.info "current #{component}"

    result = case component[:type]
             when 'harvest'
               "<Mgt_Harvest_App Year='#{component[:year]}' DOY='#{component[:doy]}' DAP='' HStg='' HCom='H' HSiz='A' HPc='100' HBmin='0' HKnDnPc='0' url='#{component[:url]}' notes='".html_safe 
             when 'planting'
               "<Mgt_Planting CropMod='S' SpeciesID='#{component[:species]}' CultivarID='' Year='#{component[:year]}' DOY='#{component[:doy]}' EYear='0' EDOY='' Ppop='#{component[:ppop]}' Ppoe='' PlMe='S' PlDs='' RowSpc='#{component[:row_spacing]}' AziR='' SDepth='#{component[:depth]}' SdWtPl='#{component[:seed_weight]}' SdAge='' ATemp='' PlPH='' url='#{component[:url]}' notes='".html_safe
             when 'tillage'
               "<Mgt_Tillage_App Year='#{component[:year]}' DOY='#{component[:doy]}' TImpl='#{component[:equipment]}' TDep='#{component[:depth]}' url='#{component[:url]}' notes='".html_safe 
             when 'fertilizer'
               "<Mgt_Fertilizer_App Year='#{component[:year]}' DOY='#{component[:doy]}' ANFer='#{component[:n_rate]}' AKFer='#{component[:k_rate]}' APFer='#{component[:p_rate]}' NCode='#{component[:fertilizer]}' url='#{component[:url]}' notes='".html_safe
             when 'irrigation'
  
    end
    result <<  component[:notes].delete("\r")
    result << "'/>".html_safe
    result
  end
end
