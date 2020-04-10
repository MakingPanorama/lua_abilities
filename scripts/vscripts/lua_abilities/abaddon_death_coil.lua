abaddon_death_coil_lua = abaddon_death_coil_lua or class({})


function abaddon_death_coil_lua:OnSpellStart()
	local target = self:GetCursorTarget()

	self.missile_speed = self:GetSpecialValueFor("missile_speed")
	self.self_damage = self:GetSpecialValueFor("self_damage")
	self.target_damage = self:GetSpecialValueFor("target_damage")
	self.heal_amount = self:GetSpecialValueFor("heal_amount")

	self:GetCaster():EmitSound("Hero_Abaddon.DeathCoil.Cast")

	local projectile_info = {
		Target = target,
		Source = self:GetCaster(),
		Ability = self, 

		EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
		iMoveSpeed = self.missile_speed,
		bDodgeable = true,
	}
	ProjectileManager:CreateTrackingProjectile(projectile_info)
	local damage_table = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		ability = self,
		damage = self.self_damage,
		damage_type = self:GetAbilityDamageType()
	}
	ApplyDamage(damage_table)

	
end

function abaddon_death_coil_lua:OnProjectileHit(target, location)

	local damage_table = {

		attacker = self:GetCaster(),
		victim = target,
		ability = self,
		damage_type = self:GetAbilityDamageType()

	}

	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		target:Heal(self.heal_amount, self:GetCaster())
		damage_table.damage = 0
	else
		damage_table.damage = self.target_damage
		ApplyDamage(damage_table)
	end
	self:GetCaster():EmitSound("Hero_Abaddon.DeathCoil.Target")
end
