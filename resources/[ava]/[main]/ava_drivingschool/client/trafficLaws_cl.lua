-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local checkedAnswers = {}
local CurrentQuestionId = 0
local CurrentScore = 0

function TrafficLawsLicense()
    RageUI.CloseAllInternal()
    CurrentActionEnabled = false

    CurrentScore = 0
    CurrentQuestionId = 0
    local canValidate = false
    NextQuestion()

    RageUI.OpenTempMenu(GetString("driving_school"), function(Items, Menu)
        local question = AVAConfig.TrafficLawsQuestions[CurrentQuestionId]
        Items:AddButton(GetString("question", CurrentQuestionId, #AVAConfig.TrafficLawsQuestions), question.question, {}, nil)

        if question.oneAnswer then
            Items:AddSeparator(GetString("one_answer"))

            for i = 1, #question.answers do
                local answer = question.answers[i]
                Items:AddButton(GetString("answer_number", string.char(string.byte("A") + i - 1)),
                    GetString("answer_subtitle", question.question, answer.label), {}, function(onSelected)
                        if onSelected then
                            -- Check answer
                            if answer.right then
                                CurrentScore = CurrentScore + 1
                            end
                            NextQuestion(Menu)
                        end
                    end)
            end
        else
            Items:AddSeparator(GetString("multiple_answers"))

            for i = 1, #question.answers do
                local answer = question.answers[i]
                Items:CheckBox(GetString("answer_number", string.char(string.byte("A") + i - 1)), GetString("answer_subtitle", question.question, answer.label),
                    checkedAnswers[i], {}, function(onSelected, IsChecked)
                        if (onSelected) then
                            checkedAnswers[i] = not checkedAnswers[i]
                            canValidate = true
                        end
                    end)
            end
            Items:AddButton(GetString("validate_answer"), GetString("validate_answer_subtile"), {
                Color = {
                    BackgroundColor = canValidate and RageUI.ItemsColour.Green or RageUI.ItemsColour.GreenDark,
                    HighLightColor = canValidate and RageUI.ItemsColour.GreenLight or RageUI.ItemsColour.GreenDark,
                },
                IsDisabled = not canValidate,
            }, function(onSelected)
                if onSelected then
                    -- Check answer
                    for i, value in pairs(checkedAnswers) do
                        if value and question.answers[i].right then
                            CurrentScore = CurrentScore + 1
                        end
                    end
                    checkedAnswers = {}
                    canValidate = false

                    NextQuestion(Menu)
                end
            end)
        end
    end, nil, AVAConfig.MenuStyle and AVAConfig.MenuStyle.textureName, AVAConfig.MenuStyle and AVAConfig.MenuStyle.textureDirectory, true)
end

function NextQuestion(Menu)
    CurrentQuestionId = CurrentQuestionId + 1
    if CurrentQuestionId > #AVAConfig.TrafficLawsQuestions then
        CurrentActionEnabled = true
        RageUI.CloseAll()
        TriggerServerEvent("ava_drivingschool:client:passedTrafficLawsTest", CurrentScore)
        return
    end

    if Menu then
        Menu.Index = Menu.Options
        RageUI.GoDown()
    end
end
