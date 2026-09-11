<template>
    <Align class="ctool-github" gap="none">
        <span class="ctool-github-name" @click="openUrl(`https://ctool.dev/`)">
            <Icon name="github" :size="12"/> <strong>Ctool</strong>
        </span>
    </Align>
</template>

<script setup lang="ts">
import {openUrl} from "@/helper/helper"
</script>

<style scoped>
.ctool-github span {
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    column-gap: 5px;
    font-size: 12px;
    height: 24px;
    padding: 2px 5px;
    text-decoration: none;
}

.ctool-github span:hover {
    color: var(--ctool-primary-hover);
}

.ctool-github .ctool-github-name {
    border: 1px solid var(--form-element-border-color);
    border-radius: 3px;
}
</style>
