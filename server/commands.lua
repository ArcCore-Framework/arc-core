Arc.Commands = {}

function Arc.Commands.AddCommand(name)
    RegisterCommand(name, function()
        print('comnand fired')
    end, false)
end