require("Actions")

vrjLua.appendToModelSearchPath("/home/users/rpavlik/src/windfarm/")
vrjLua.appendToModelSearchPath("x:/users/rpavlik/src/windfarm/")
vrjLua.appendToModelSearchPath("/home/rpavlik/Downloads/")


RelativeTo.Room:addChild(
	Lighting{
		number = 0,
		ambient = 1.0,
		diffuse = 0.7,
		specular = 0.5,
		position = {0, 3, 2},
		positional = false
	}
)
RelativeTo.Room:addChild(
	Lighting{
		number = 1,
		ambient = 1.0,
		diffuse = 0.7,
		specular = 0.5,
		position = {0, 6, 2},
		positional = true
	}
)


farm = --AmbientIntensity{
	--intensity = 0.8,
	Group{
	        Model( "FarmField.ive")
	}
--}

RelativeTo.World:addChild(farm)



blades = Transform{
	position = {0.0, 52.5, 2.5},
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = 0.05,
		Model( "blades.ive")
	}
}


function bladeAction(dt)
	local angle = 0
	local q = osg.Quat()
	while true do
		angle = angle + 25 * dt
		q:makeRotate(Degrees(angle), Axis{0, 0, 1})
		blades:setAttitude(q)
		dt = Actions.waitForRedraw()
	end
end

Actions.addFrameAction(bladeAction)

base = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
    scale = 0.05,
	Model( "turbineb.ive")
}


turbine = Transform{
    position = {0,-17,0},
	base,
	blades
}

RelativeTo.World:addChild(
	Group{
		Transform{
			position = {30, 0, 160},
			turbine
		},
		Transform{
			position = {50, 0, 140},
			turbine
		},
		Transform{
			position = {70, 0, 120},
			turbine
		},
		Transform{
			position = {90, 0, 100},
			turbine
		},
		Transform{
			position = {110, 0, 80},
			turbine
		},
		Transform{
			position = {130, 0, 60},
			turbine
		},
		Transform{
			position = {150, 0, 40},
			turbine
		},
		Transform{
			position = {170, 0, 20},
			turbine
		}
	}
)


