require("Scene")

vrjLua.appendToModelSearchPath("/home/users/rpavlik/src/windfarm/")
vrjLua.appendToModelSearchPath("/home/rpavlik/Downloads/")

farm = Transform{
    children = {
        Model( "FarmField.ive")
    }
}
navtransform:addChild(farm)



blades = Transform{
	position = {0.0, 52.5, 2.5},
	children = {
		Transform{
			orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
			scale = 0.05,
			children = {
				Model( "blades.ive")
			}
		}
	}
}

function setAction(node, action)
	local lastClock = os.clock()
	local co = coroutine.create(action)
	coroutine.resume(co, node, 0)
	local c = osgLua.NodeCallback(
		function(n, nodeVisitor)
			local newClock = os.clock()
			local elapsed = newClock - lastClock
			lastClock = newClock
			if coroutine.status(co) == 'dead' then
				node:removeUpdateCallback(c)
			else
				coroutine.resume(co, osgnav.appProxy:getTimeDelta())
			end
			lastTime = newTime
			--c:traverse(n, nodeVisitor)
		end)
	node:addUpdateCallback(c)
end

function bladeAction(node, elapsed)
	local angle = 0
	local q = osg.Quat()
	while true do
		angle = angle + 25 * elapsed
		q:makeRotate(Degrees(angle), Axis{0, 0, 1})
		node:setAttitude(q)
		elapsed = coroutine.yield()
	end
end

setAction(blades, bladeAction)

base = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
    scale = 0.05,
	children = {
        Model( "turbineb.ive")
	}
}

	
turbine = Transform{
    position = {0,-17,0},   
    children = {
		base,
		blades
    }
}




navtransform:addChild(Transform{
    position = {30, 0, 160},
    children = {turbine}
    }
)
navtransform:addChild(Transform{
    position = {50, 0, 140},
    children = {turbine}
    }
)

navtransform:addChild(Transform{
    position = {70, 0, 120},
    children = {turbine}
    }
)
navtransform:addChild(Transform{
    position = {90, 0, 100},
    children = {turbine}
    }
)

navtransform:addChild(Transform{
    position = {110, 0, 80},
    children = {turbine}
    }
)
navtransform:addChild(Transform{
    position = {130, 0, 60},
    children = {turbine}
    }
)
navtransform:addChild(Transform{
    position = {150, 0, 40},
    children = {turbine}
    }
)
navtransform:addChild(Transform{
    position = {170, 0, 20},
    children = {turbine}
    }
)


