require("Actions")
require("DebugAxes")

-- Look for models in the same directory as this file.
require("getScriptFilename")
fn = getScriptFilename()
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)

farm = --AmbientIntensity{
	--intensity = 0.8,
	Group{
		Model("FarmField.ive"),
		DebugAxes.node
	}
--}

RelativeTo.World:addChild(farm)



blades = Transform{
	position = {0.0, 52.5, 2.5},
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = 0.05,
		Model("blades.ive"),
		DebugAxes.node
	},
	DebugAxes.node
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
	Model("turbineb.ive")
}


turbine = Transform{
    position = {0,-17,0},
	base,
	blades,
	DebugAxes.node
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
		},
		DebugAxes.node
	}
)

print("Run DebugAxes.show() to show coordinate axes") 
--DebugAxes.show()
DebugAxes.hide()

light = {}
function addLight(arg)
	local l = osg.Light()
	l:setLightNum(arg.number)
	light[arg.number] = l
	
	local ls = osg.LightSource()
	ls:setLight(l)
	ls:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	
	l:setAmbient(osg.Vec4(arg.ambient, arg.ambient, arg.ambient, 1))
	l:setDiffuse(osg.Vec4(arg.diffuse, arg.diffuse, arg.diffuse, 1))
	l:setSpecular(osg.Vec4(arg.specular, arg.specular, arg.specular, 1))
	
	l:setPosition(arg.position)
	return ls
end

lightGroup = osg.Group()
RelativeTo.Room:addChild(lightGroup)
ss = RelativeTo.Room:getOrCreateStateSet()
	local dir = osg.Vec3f(0, -1, 0)
	dir:normalize()
	lightGroup:addChild(
		addLight{
			number = 0,
			ambient = 0.8,
			diffuse = 0.7,
			specular = 0.0,
			position = osg.Vec4(0, 3, 2, 1),
			direction = dir
		}
	)
	
	ss:setAssociatedModes(light[0], osg.StateAttribute.Values.ON)
	lightGroup:addChild(
		addLight{
			number = 1,
			ambient = 0.0,
			diffuse = 0.5,
			specular = 0.1,
			position = osg.Vec4(0, 2, 2, 0),
			direction = osg.Vec3f(0, -1, 0)
		}
	)
	ss:setAssociatedModes(light[1], osg.StateAttribute.Values.ON)

