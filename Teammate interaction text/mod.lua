local init_original = HUDTeammate.init
local set_name_original = HUDTeammate.set_name
local set_carry_info_original = HUDTeammate.set_carry_info
local set_callsign_original =  HUDTeammate.set_callsign
local set_state_original = HUDTeammate.set_state
local teammate_progress_original = HUDTeammate.teammate_progress
	
function HUDTeammate:init(...)
init_original(self, ...)
	
	local radial_health_panel = self._player_panel:child( "radial_health_panel" )

	local name_panel = self._panel:panel({
		name 	= "name_panel",
		w 		= self._panel:w() - self._panel:child( "callsign_bg" ):w() - ( not self._main_player and radial_health_panel:w() or 0 ),
		h 		= self._panel:child( "name_bg" ):h(),
		x 		= self._panel:child( "name_bg" ):x(),
		y 		= self._panel:child( "name_bg" ):y()
	})
	
	if not self._main_player then
		
		local interact_panel = self._player_panel:child( "interact_panel" )
	
		local interact_info = interact_panel:text({name = "interact_info"})
		
		local interact_text = name_panel:text({
			name 		= "interact_text",
			text 		= "",
			layer 		= 1,
			visible 	= false,
			color 		= Color.white,
			w 			= self._panel:child( "name" ):w(),
			h 			= self._panel:child( "name" ):h(),
			vertical 	= "bottom",
			font_size 	= tweak_data.hud_players.name_size,
			font 		= tweak_data.hud_players.name_font
		})
		
	end
	
	self._new_name = name_panel:text({
		name 		= "name",
		text 		= " Dallas",
		layer 		= 1,
		color 		= Color.white,
		y 			= 0,
		vertical 	= "bottom",
		font_size 	= tweak_data.hud_players.name_size,
		font 		= tweak_data.hud_players.name_font
	})
	
	self._panel:child( "name" ):set_visible( false )

end

function HUDTeammate:set_name(...)
set_name_original(self, ...)

		local teammate_panel = self._panel
	    local name = teammate_panel:child( "name" )
	    local name_bg = teammate_panel:child( "name_bg" )
	
	    self._new_name:stop()
	
	    self._new_name:set_text( name:text() )
	
	    local x , y , w , h = self._new_name:text_rect()
	    self._new_name:set_left( 0 )
	    self._new_name:set_size( w , h )
	    name_bg:set_w( self._new_name:w() + 4 )
	
	    if self._panel:child( "name_panel" ):w() < name_bg:w() then
		    self._new_name:animate( callback( self , self , "_animate_name" ) , name_bg:w() - self._panel:child( "name_panel" ):w() + 2 )
	    end
end

function HUDTeammate:set_callsign(id)
     set_callsign_original(self, id)

	 local teammate_panel = self._panel:child( "player" )
	 local radial_health_panel = teammate_panel:child( "radial_health_panel" )

	 self._panel:child( "name" ):set_color( tweak_data.chat_colors[ id ] or Color.white )
	 self._new_name:set_color( tweak_data.chat_colors[ id ] or Color.white )

        if not self._main_player and self:peer_id() and managers.network:session() and managers.network:session():peer( self:peer_id() ):is_cheater() then
		    self._panel:child( "name" ):set_color( tweak_data.screen_colors.pro_color )
		    self._new_name:set_color( tweak_data.screen_colors.pro_color )
		    self._panel:child( "callsign" ):set_color( tweak_data.screen_colors.pro_color )
	    end

end 

function HUDTeammate:set_state(state)
     set_state_original(self, state)
	    if not self._main_player then
		    self._panel:child( "name_panel" ):set_y( self._panel:child( "name" ):y() )
		
     	end
end 

function HUDTeammate:teammate_progress(enabled ,tweak_data_id ,timer ,success)
     teammate_progress_original(self, enabled ,tweak_data_id ,timer ,success)

     if not self._player_panel:child( "interact_panel" ):child( "interact_info" ) then return end	
	    
     self._panel:child( "name_panel" ):child( "interact_text" ):stop()
     self._panel:child( "name_panel" ):child( "interact_text" ):set_left( 0 )
	
	    if enabled and not self._main_player and self:peer_id() then
	
		    self._new_name:set_alpha( 0.1 )
	
     		self._panel:child( "name_panel" ):child( "interact_text" ):set_visible( true )
	    	self._panel:child( "name_panel" ):child( "interact_text" ):set_text( " " .. managers.hud:_name_label_by_peer_id( self:peer_id() ).panel:child( "action" ):text() )
		
	    	local x , y , w , h = self._panel:child( "name_panel" ):child( "interact_text" ):text_rect()
	    	self._panel:child( "name_panel" ):child( "interact_text" ):set_size( w , h )
		
	    	if self._panel:child( "name_panel" ):child( "interact_text" ):w() + 4 > self._panel:child( "name_bg" ):w() then
			    self._panel:child( "name_bg" ):set_w( self._panel:child( "name_panel" ):child( "interact_text" ):w() + 4 )
		    end
		
		    if self._panel:child( "name_panel" ):w() < self._panel:child( "name_panel" ):child( "interact_text" ):w() + 4 then
			    self._panel:child( "name_panel" ):child( "interact_text" ):animate( callback( self , self , "_animate_name" ) , self._panel:child( "name_bg" ):w() - self._panel:child( "name_panel" ):w() + 2 )
		    end
		
	    elseif not success and not self._main_player then
	
		    local x , y , w , h = self._new_name:text_rect()
		    self._new_name:set_size( w , h )
		
		    self._panel:child( "name_panel" ):child( "interact_text" ):stop()
		    self._panel:child( "name_panel" ):child( "interact_text" ):set_left( 0 )
		
		    self._new_name:set_alpha( 1 )
		    self._panel:child( "name_panel" ):child( "interact_text" ):set_visible( false )
		    self._panel:child( "name_bg" ):set_w( w + 4 )
		
	    end
	
	    if success then
	
		    self._new_name:set_alpha( 1 )
		    self._panel:child( "name_panel" ):child( "interact_text" ):set_visible( false )
		    self._panel:child( "name_bg" ):set_w( self._new_name:w() + 4 )
	
	    end
	
	    self._panel:child( "name_panel" ):child( "interact_text" ):set_color( tweak_data.chat_colors[ self._peer_id ] or Color.white )
	    
		if not self._main_player and self:peer_id() then
        
		local peer = managers.network:session() and managers.network:session():peer(self:peer_id())
        
		    if peer and peer:is_cheater() then
                self._panel:child( "name_panel" ):child( "interact_text" ):set_color( tweak_data.screen_colors.pro_color )
            end
        end
end

function HUDTeammate:set_carry_info(...)
     set_carry_info_original(self, ...)
        if self._peer_id then  
	        if managers.network:session():peer( self._peer_id ):is_cheater() then
	            self._player_panel:child( "carry_panel" ):child( "bag" ):set_color( tweak_data.screen_colors.pro_color ) 
	        else 
                self._player_panel:child( "carry_panel" ):child( "bag" ):set_color( tweak_data.chat_colors[ self._peer_id ] )
	        end
        end
end

function HUDTeammate:_animate_name( name, width )

	local t = 0
	
	while true do
		
		t = t + coroutine.yield()
		name:set_left( width * ( math.sin( 90 + t * 50 ) * 0.5 - 0.5 ) )
		
	end

end

-- this could probably be done better
function HUDTeammate:add_special_equipment(data)

    local team_color
    if self._peer_id then
        team_color = tweak_data.chat_colors[self._peer_id]
    elseif not self._ai then
        team_color = tweak_data.chat_colors[managers.network:session():local_peer():id()]
    end
    if not self._main_player and self:peer_id() and managers.network:session() and managers.network:session():peer( self:peer_id() ):is_cheater() then
        team_color = tweak_data.screen_colors.pro_color
    end
	
	local teammate_panel = self._panel
	local special_equipment = self._special_equipment
	local id = data.id
	local equipment_panel = teammate_panel:panel({
		name = id,
		layer = 0,
		y = 0
	})
	local icon, texture_rect = tweak_data.hud_icons:get_icon_data(data.icon)
	equipment_panel:set_size(27, 27)
	local bitmap = equipment_panel:bitmap({
		name = "bitmap",
		texture = icon,
	    color = team_color or Color.white,
		texture_rect = texture_rect,
		layer = 0,
		w = equipment_panel:w(),
		h = equipment_panel:h(),
		rotation = 360
	})
	local flash_icon = equipment_panel:bitmap({
		name = "bitmap",
		texture = icon,
		color = team_color or Color.white,
		texture_rect = texture_rect,
		layer = 1,
		w = equipment_panel:w() + 2,
		h = equipment_panel:h() + 2,
		rotation = 360
	})
	local w = teammate_panel:w()
	equipment_panel:set_x(w - (equipment_panel:w() + 0) * #special_equipment)
	table.insert(special_equipment, equipment_panel)
	local amount, amount_bg
	if data.amount then
		amount_bg = equipment_panel:child("amount_bg") or equipment_panel:bitmap({
			name = "amount_bg",
			texture = "guis/textures/pd2/equip_count",
			color = Color.white,
			layer = 2,
			rotation = 360
		})
		amount = equipment_panel:child("amount") or equipment_panel:text({
			name = "amount",
			text = tostring(data.amount),
			font = "fonts/font_small_noshadow_mf",
			font_size = 12,
			color = Color.black,
			align = "center",
			vertical = "center",
			layer = 3,
			w = equipment_panel:w(),
			h = equipment_panel:h(),
			rotation = 360
		})
		amount_bg:set_center(bitmap:center())
		amount_bg:move(7, 7)
		amount_bg:set_visible(1 < data.amount)
		amount:set_center(amount_bg:center())
		amount:set_visible(1 < data.amount)
	end
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	flash_icon:set_center(bitmap:center())
	flash_icon:animate(hud.flash_icon, nil, equipment_panel)
	self:layout_special_equipments()
end