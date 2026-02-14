--- STEAMODDED HEADER
--- MOD_NAME: Silly Decks
--- MOD_ID: sdecks
--- MOD_AUTHOR: cassiepepsi
--- MOD_DESCRIPTION: Adds several joke decks.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

----------------------------------------------
------------MOD CODE -------------------------

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
    quantum_enhancements = true
}

local atlas_decks = SMODS.Atlas {
	key = "deckicons",
	path = "Decks/deck.png",
	px = 71,
	py = 95,
}


SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 28,
    py = 28
}

SMODS.Atlas({key = 'sdecks_cards', path = 'Suits/8BitDeck.png', px = 71, py = 95})
SMODS.Atlas({key = 'sdecks_cards_hc', path = 'Suits/8BitDeck_opt2.png', px = 71, py = 95})

SMODS.Atlas({key = 'sdecks_suits', path = 'Suits/ui_assets.png', px = 18, py = 18})
SMODS.Atlas({key = 'sdecks_suits_hc', path = 'Suits/ui_assets_opt2.png', px = 18, py = 18})


lc_colors = {
    Hearts = HEX('f03464'),
    Diamonds = HEX('f06b3f'),
    Spades = HEX("403995"),
    Clubs = HEX("235955"),
}
hc_colors = {
    Hearts = HEX('f83b2f'),
    Diamonds = HEX('e29000'),
    Spades = HEX("4f31b9"),
    Clubs = HEX("008ee6"),
}

SMODS.Suit{ -- Diamonds?
    key = 'Diamonds?', card_key = 'DIAMONDS_2',
    hidden = true,
    loc_txt = {singular = "Diamond?", plural = "Diamonds?"},
    lc_atlas = 'sdecks_cards', hc_atlas = 'sdecks_cards_hc',
    lc_ui_atlas = 'sdecks_suits', hc_ui_atlas = 'sdecks_suits_hc',
    pos = { x = 0, y = 2 }, ui_pos = { x = 1, y = 1 },
    lc_colour = lc_colors.Diamonds, hc_colour = hc_colors.Diamonds,
    in_pool = function() return false end
}
SMODS.Suit{ -- Clubs?
    key = 'Clubs?', card_key = 'CLUBS_2',
    hidden = true,
    loc_txt = {singular = "Club?", plural = "Clubs?"},
    lc_atlas = 'sdecks_cards', hc_atlas = 'sdecks_cards_hc',
    lc_ui_atlas = 'sdecks_suits', hc_ui_atlas = 'sdecks_suits_hc',
    pos = { x = 0, y = 1 }, ui_pos = { x = 2, y = 1 },
    lc_colour = lc_colors.Clubs, hc_colour = hc_colors.Clubs,
    in_pool = function() return false end
}
SMODS.Suit{ -- Hearts?
    key = 'Hearts?', card_key = 'HEARTS_2',
    hidden = true,
    loc_txt = {singular = "Heart?", plural = "Hearts?"},
    lc_atlas = 'sdecks_cards', hc_atlas = 'sdecks_cards_hc',
    lc_ui_atlas = 'sdecks_suits', hc_ui_atlas = 'sdecks_suits_hc',
    pos = { x = 0, y = 0 }, ui_pos = { x = 0, y = 1 },
    lc_colour = lc_colors.Hearts, hc_colour = hc_colors.Hearts,
    in_pool = function() return false end
}
SMODS.Suit{ -- Spades?
    key = 'Spades?', card_key = 'SPADES_2',
    hidden = true,
    loc_txt = {singular = "Spade?", plural = "Spades?"},
    lc_atlas = 'sdecks_cards', hc_atlas = 'sdecks_cards_hc',
    lc_ui_atlas = 'sdecks_suits', hc_ui_atlas = 'sdecks_suits_hc',
    pos = { x = 0, y = 3 }, ui_pos = { x = 3, y = 1 },
    lc_colour = lc_colors.Spades, hc_colour = hc_colors.Spades,
    in_pool = function() return false end
}

local card_change_suit = Card.change_suit
function Card:change_suit(new_suit)
    local change = self.base.suit ~= new_suit
    card_change_suit(self, new_suit)
    if not change then return end
    if G.GAME.sdecks_ban_regular_suits and contains({"Hearts", "Clubs", "Spades", "Diamonds"},new_suit) then 
        card_change_suit(self, 'sdecks_'..new_suit..'?')
    end
    if G.GAME.sdecks_make_spades_negative then
        if not self.edition and self:is_suit("Spades") then self:set_edition("e_negative",true,true) end
        if self.edition and self.edition.key == "e_negative" and not self:is_suit("Spades") then self:set_edition(nil,true,true) end 
    end
end

local card_set_base = Card.set_base
function Card:set_base(card, initial)
    local change = self.base and card and (self.base.suit ~= card.suit)
    local start_card = self.base
    card_set_base(self, card, initial)
    if not change then return end
    if not G.GAME.selected_back then return end 
    if G.GAME.sdecks_ban_regular_suits and contains({"Hearts", "Clubs", "Spades", "Diamonds"},card.suit) then 
        card_change_suit(self, 'sdecks_'..card.suit..'?')
    end
    if G.GAME.sdecks_make_spades_negative then
        if not self.edition and self:is_suit("Spades") then self:set_edition("e_negative",true,true) end
        if self.edition and self.edition.key == "e_negative" and not self:is_suit("Spades") then self:set_edition(nil,true,true) end 
    end
end

local card_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    card_set_ability(self,center,initial,delay_sprites)
    if (center ~= nil) and self.base and G.GAME.selected_back and G.GAME.sdecks_make_spades_negative then
        if not self.edition and self:is_suit("Spades") then
            self:set_edition("e_negative",true,true) end
        if self.edition and self.edition.key == "e_negative" and not self:is_suit("Spades") then
            self:set_edition(nil,true,true) end 
    end
end

--- EMPTY DECK
SMODS.Back{
    name = "Empty Deck",
    key = "empty",
    atlas = 'deckicons', 
    pos = {x = 0, y = 0},
    loc_txt = {
        name ="Empty Deck",
        text={
            "Start with an",
            "empty Deck",
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                while #G.playing_cards ~= 0 do
                    G.playing_cards[1]:remove()
                end
                SMODS.add_card{key='j_marble', edition='e_holo'}
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}

--- VANTABLACK DECK
SMODS.Back{
    name = "Vantablack Deck",
    key = "vanta",
    atlas = 'deckicons', 
    pos = {x = 1, y = 0},
    loc_txt = {
        name ="Vantablack Deck",
        text={
            "{C:black}Spades{} are always",
            "{C:dark_edition}Negative{}",
        },
    },
    apply = function(self)

        G.GAME.sdecks_make_spades_negative = true

        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    local card = G.playing_cards[i]
                    if card:is_suit('Spades') then
                        card:set_edition('e_negative', true, true)
                    end
                end
                return true
            end
        }))
    end
}

--- LUCKY DECK
--- SMODS.Back{
---     name = "Lucky Deck",
---     key = "lucky",
---     atlas = 'deckicons', 
---     pos = {x = 2, y = 0},
---     loc_txt = {
---         name ="Lucky Deck",
---         text={
---             "Start with a Deck",
---             "full of {C:attention}Lucky Sevens{}",
---         },
---     },
---     apply = function(self)
---         G.E_MANAGER:add_event(Event({
---             func = function()
---                 for _, card in ipairs(G.playing_cards) do
---                     assert(SMODS.change_base(card, nil, '7'))
---                     card:set_ability(G.P_CENTERS["m_lucky"])
---                 end
---                 return true
---             end
---         }))
---     end
--- }

--- SINGULARITY DECK
SMODS.Back{
    name = "Singularity Deck",
    key = "single",
    atlas = 'deckicons', 
    pos = {x = 3, y = 0},
    config = {joker_slot = -4},
    loc_txt = {
        name ="Singularity Deck",
        text={
            "{C:attention}1{} Joker slot",
            "{C:attention}+10{} free rerolls",

        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_free_rerolls(10)                
                return true
            end
        }))
    end
}

--- CONFUSED DECK
SMODS.Back{
    name = "Confused Deck",
    key = "confused",
    atlas = 'deckicons', 
    pos = {x = 5, y = 0},

    loc_txt = {
        name ="Confused Deck",
        text={
            "Suit effects don't work",
            "All {C:attention}Enhanced{} cards",
            "count as {C:attention}Wild Cards{}"
        },
    },
    apply = function()
        G.GAME.sdecks_ban_regular_suits = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    local card = G.playing_cards[i]
                    card:change_suit('sdecks_'..card.base.suit..'?', nil, true)
                end
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.check_enhancement then
            if context.other_card.config.center.key ~= 'c_base' then
                return {m_wild = true}
            end
        end
        if context.playing_card_added then
            for _, other_card in pairs(context.cards) do
                if contains({"Hearts", "Clubs", "Spades", "Diamonds"},other_card.base.suit) then
                    other_card:change_suit('sdecks_'..other_card.base.suit..'?')
                end
            end
        end
    end
}

--- STANDARD DECK
SMODS.Back{
    name = "Standard Deck",
    key = "standard",
    atlas = 'deckicons', 
    pos = {x = 6, y = 0},
    loc_txt = {
        name ="Standard Deck",
        text={
            "{C:attention}Playing cards{} at start",
            "of run may have an",
            "{C:enhanced}Enhancement{}, {C:dark_edition}Edition{},",
            " and/or a {C:attention}Seal{}"
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    card:set_edition(SMODS.poll_edition('sdecks_std_edition',nil,true,true),true,true)
                    local enhancement = SMODS.poll_enhancement('sdecks_std_enhance')
                    if enhancement ~= nil then card:set_ability(enhancement,true,true) end
                    card:set_seal(SMODS.poll_seal('sdecks_std_seal'),true,true)
                end
                return true
            end
        }))
    end
}

--- ANKH DECK
SMODS.Back{
    name = "Ankh Deck",
    key = "ankh",
    atlas = 'deckicons', 
    pos = {x = 7, y = 0},

    loc_txt = {
        name ="Ankh Deck",
        text={
                    "After defeating each",
                    "{C:attention}Boss Blind{}, gain a",
                    "{C:dark_edition}Negative{} copy of a",
                    "random {C:attention}Joker{}"
        },
    },

    calculate = function(self, card, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss and #G.jokers.cards > 0 then
            local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('ankh_deck_choice'))
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                card:start_materialize()
                card:add_to_deck()
                card:set_edition('e_negative', true)
                G.jokers:emplace(card)

                attention_text({
                    text = localize('k_copied_ex'), scale = 0.9, hold = 1.4,
                    backdrop_colour = G.C.CHIPS,
                    align = 'tm', major = G.deck, offset = {x = 0, y = -0.8},
                    silent = true
                    })

                return true end }))

        end
    end
}

--- DISCOVERED DECK
SMODS.Back{
    name = "Discovered Deck",
    key = "discovered",
    atlas = 'deckicons', 
    pos = {x = 8, y = 0},

    loc_txt = {
        name ="Discovered Deck",
        text={
                    "Start run with",
                    "only {C:attention}Face Cards",
                    "in your deck",
        },
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local i = 1
                while #G.playing_cards ~= 12 do
                    if not G.playing_cards[i]:is_face() then
                        G.playing_cards[i]:remove()
                    else
                        i = i+1
                    end
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}

--- HERCULEAN DECK
SMODS.Back{
    name = "Herculean Deck",
    key = "herculean",
    atlas = 'deckicons', 
    pos = {x = 2, y = 0},

    loc_txt = {
        name ="Herculean Deck",
        text={
                    "Increases rank of",
                    "all scored cards",
                    "by {C:attention}1",
        },
    },

    calculate = function(self, card, context)
        if context.before then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                return true end }))
            end
        if context.cardarea == G.play and context.individual then
            local scored_card = context.other_card
            local percent = 1.15 - (1-0.999)/(#G.play.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() scored_card:flip();play_sound('card1', percent);scored_card:juice_up(0.3, 0.3);return true end }))
            delay(0.2)
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local suit_prefix = string.sub(scored_card.base.suit, 1, 1)..'_'
                local rank_suffix = scored_card.base.id == 14 and 2 or math.min(scored_card.base.id+1, 14)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                scored_card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))

            local percent = 0.85 + (1-0.999)/(#G.play.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() scored_card:flip();play_sound('tarot2', percent, 0.6);scored_card:juice_up(0.3, 0.3);return true end }))

        end
    end
}


--- NOPE DECK
SMODS.Back{
    name = "Fallacy Deck",
    key = "fallacy",
    atlas = 'deckicons', 
    pos = {x = 9, y = 0},

    loc_txt = {
        name ="Fallacy Deck",
        text={
            "All {C:attention}listed {C:green,E:1,S:1.1}probabilities",
            "become {C:green}1 in 2{C:inactive}"
        },
    },

    calculate = function(self, card, context)
        if context.fix_probability and not context.blueprint then
            local top = 1
            if next(SMODS.find_card('j_oops')) then top = 2 end
            return { denominator = 2, numerator = top } end
        end
}

--- CASINO DECK
SMODS.Back{
    name = "Casino Deck",
    key = "casino",
    atlas = 'deckicons', 
    pos = {x = 0, y = 1},

    loc_txt = {
        name ="Casino Deck",
        text={
            "After defeating each",
            "{C:attention}Boss Blind{}, reset",
            "deck to initial state"
        },
    },

    calculate = function(self, card, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
        G.E_MANAGER:add_event(Event({
            func = function()
                while #G.playing_cards ~= 0 do
                    G.playing_cards[1]:remove()
                end
                for _, suit in pairs({'S', 'H', 'C', 'D'}) do
                    for __, rank in pairs({'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}) do
                        SMODS.add_card({set = 'Base', suit=suit, rank=rank, area=G.deck, skip_materialize=true})
                    end
                end
                
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_reset'), scale = 0.9, hold = 1.4,
                    backdrop_colour = G.C.IMPORTANT,
                    align = 'tm', major = G.deck, offset = {x = 0, y = -0.8},
                    silent = true
                    })

                    play_sound('tarot2', 1, 0.4)
                return true end }))

                return true
            end
        }))
        end
    end
}

--- IONIZED DECK
SMODS.Back{
    name = "Ionized Deck",
    key = "ionized",
    atlas = 'deckicons', 
    pos = {x = 1, y = 1},

    loc_txt = {
        name ="Ionized Deck",
        text={
            "{C:blue}Hands{} and {C:red}Discards{}",
            "are pooled together",
        },
    },

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local hand_UI = G.HUD:get_UIE_by_ID('hand_UI_count')
            local discard_UI = G.HUD:get_UIE_by_ID('discard_UI_count')
            G.E_MANAGER:add_event(Event({
                func = function()
                    local total_hands_discards = G.GAME.current_round.discards_left + G.GAME.current_round.hands_left
                    ease_discard(G.GAME.current_round.hands_left, nil, false)
                    ease_hands_played(total_hands_discards-G.GAME.current_round.hands_left, nil)

                    hand_UI.config.object.colours = {{0.8, 0.45, 0.85, 1}}
                    hand_UI.config.object:update()
                    discard_UI.config.object.colours = {{0.8, 0.45, 0.85, 1}}
                    discard_UI.config.object:update()

                    return true
                end
            }))
        end
        if context.press_play then
            G.E_MANAGER:add_event(Event({trigger = 'after',
                func = function()
                    ease_discard(-1, nil, false)
                    return true
                end
            }))
        end
        if context.pre_discard and not context.hook then
            G.E_MANAGER:add_event(Event({trigger = 'before',
                func = function()
                    ease_hands_played(-1, nil)
                    return true
                end
            }))
            if G.GAME.current_round.hands_left <= 1 then
                G.E_MANAGER:add_event(Event({trigger = 'after',
                    func = function()
                        G.GAME.current_round.hands_left = 0
                        G.GAME.current_round.discards_left = 0
                        G.STATE = G.STATES.GAME_OVER
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
            end
        end
        if context.end_of_round then
            local hand_UI = G.HUD:get_UIE_by_ID('hand_UI_count')
            local discard_UI = G.HUD:get_UIE_by_ID('discard_UI_count')
            G.E_MANAGER:add_event(Event({
                func = function()
                    hand_UI.config.object.colours = {G.C.BLUE}
                    hand_UI.config.object:update()
                    discard_UI.config.object.colours = {G.C.RED}
                    discard_UI.config.object:update()
                    return true
                end
            }))
        end

    end
}

--- WASTEFUL DECK
SMODS.Back{
    name = "Wasteful Deck",
    key = "wasteful",
    atlas = 'deckicons', 
    pos = {x = 2, y = 1},

    loc_txt = {
        name ="Wasteful Deck",
        text={
            "{C:red}Discarded{} cards",
            "are destroyed",
        },
    },

    calculate = function(self, card, context)
        if context.discard then return { remove = true } end
    end
}

--- REWIND DECK
SMODS.Back{
    name = "Rewind Deck",
    key = "rewind",
    atlas = 'deckicons', 
    pos = {x = 3, y = 1},

    loc_txt = {
        name ="Rewind Deck",
        text={
            "Retrigger all {C:attention}Jokers{}",
            "Required score is multiplied",
            "by {C:attention}Ante{} number"
        },
    },

    calculate = function(self, card, context)
        if context.retrigger_joker_check then
            return { repetitions = 1 }
        end
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
            G.GAME.starting_params.ante_scaling = (G.GAME.round_resets.ante) + 1
        end
    end
}

local ref_get_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append, ...)
    local pool, pool_key = ref_get_pool(_type, _rarity, _legendary, _append, ...)

    if _type == "Joker" and G.GAME.sdecks_ban_vanilla_jokers then
        local new_pool = {}
        for i, v in ipairs(pool) do
            if v ~= 'UNAVAILABLE' and G.P_CENTERS[v].original_mod then
                new_pool[#new_pool+1] = v
            end
        end

        if #new_pool == 0 then new_pool[1] = 'j_joker' end

        pool = new_pool
    end

    return pool, pool_key
end

--- ROCKY ROAD DECK
SMODS.Back{
    name = "Rocky Road Deck",
    key = "rockyroad",
    atlas = 'deckicons', 
    pos = {x = 4, y = 1},

    loc_txt = {
        name ="Rocky Road Deck",
        text={
            "Only modded {C:attention}Jokers{}",
            "can appear",
        },
    },

    apply = function(self)
        G.GAME.sdecks_ban_vanilla_jokers = true
    end,

}

--- BUSTED DECK
SMODS.Back{
    name = "Busted Deck",
    key = "busted",
    atlas = 'deckicons', 
    pos = {x = 4, y = 0},
    loc_txt = {
        name ="Busted Deck",
        text={
            "Has the upsides of",
            "all vanilla decks",
        },
    },
    config = {
        remove_faces = true,
        hands = 1,
        discards = 1,
        dollars = 10,
        extra_hand_bonus = 2, extra_discard_bonus = 1,
        joker_slot = 1,
        consumables = {'c_fool', 'c_fool', 'c_hex'},
        vouchers = {'v_tarot_merchant','v_planet_merchant', 'v_overstock_norm', 'v_crystal_ball', 'v_telescope'},
        spectral_rate = 2,
        hand_size = 2,
        randomize_rank_suit = true
    },
    
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Clubs' then 
                        v:change_suit('Spades')
                    end
                    if v.base.suit == 'Diamonds' then 
                        v:change_suit('Hearts')
                    end
                end
            return true
            end
        }))
    end,

    trigger_effect = function(self, args)
        if args.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
            add_tag(Tag('tag_double'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
        end

        if args.context == 'blind_amount' then
            return 
        end

        if args.context == 'final_scoring_step' then
            local tot = args.chips + args.mult
            args.chips = math.floor(tot/2)
            args.mult = math.floor(tot/2)
            update_hand_text({delay = 0}, {mult = args.mult, chips = args.chips})

            G.E_MANAGER:add_event(Event({
                func = (function()
                    local text = localize('k_balanced')
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94*1.5, 0.2)
                    play_sound('tarot1', 1.5)
                    ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                    ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                    attention_text({
                        scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay =  4.3,
                        func = (function() 
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay =  6.3,
                        func = (function() 
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                end)
            }))

            delay(0.6)
            return args.chips, args.mult
        end
    end

}


local atlas_sleeves = SMODS.Atlas {
	key = "decksleeves",
	path = "Decks/decksleeves.png",
	px = 73,
	py = 95,
}


if next(SMODS.find_mod("CardSleeves")) then

    deck_list = {'empty', 'vanta', 'single', 'confused', 'standard', 'ankh', 'discovered', 'herculean', 'fallacy', 'casino', 'ionized', 'wasteful', 'rewind', 'rockyroad'}

    for k, v in ipairs(deck_list) do

        deck_to_copy = v
        deck_id = "b_sdecks_" .. deck_to_copy

        CardSleeves.Sleeve {
            key = deck_to_copy,
            atlas = "decksleeves",
            pos = { x = (k-1)%5, y = math.floor((k-1)/5) },
            config = SMODS.Back.obj_table[deck_id].config,
            loc_txt = {
                name = string.gsub(SMODS.Back.obj_table[deck_id].loc_txt.name,"Deck","Sleeve"),
                text = SMODS.Back.obj_table[deck_id].loc_txt.text
            },

            calculate = SMODS.Back.obj_table[deck_id].calculate,
            apply = SMODS.Back.obj_table[deck_id].apply,
        }
    end

end

----------------------------------------------
------------MOD CODE END---------------------