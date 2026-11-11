import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import {
  CheckboxInput, // ZH EDIT ADDITION - TTS_EXPRESSION
  type Feature, // ZH EDIT ADDITION - TTS_EXPRESSION
  type FeatureChoiced,
  type FeatureChoicedServerData,
  type FeatureNumeric,
  FeatureShortTextInput, // ZH EDIT ADDITION - TTS_EXPRESSION
  FeatureSliderInput,
  type FeatureToggle, // ZH EDIT ADDITION - TTS_EXPRESSION
  type FeatureValueProps,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

function FeatureTTSDropdownInput(
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) {
  const { act } = useBackend();

  return (
    <Stack>
      <Stack.Item grow>
        <FeatureDropdownInput {...props} />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_voice');
          }}
          icon="play"
          width="100%"
          height="100%"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_voice_robot');
          }}
          icon="robot"
          width="100%"
          height="100%"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_blips');
          }}
          icon="leaf"
          width="100%"
          height="100%"
        />
      </Stack.Item>
      {/* ZH EDIT ADDITION START - TTS_EXPRESSION */}
      <Stack.Item>
        <Button
          icon="wand-magic-sparkles"
          tooltip="Design or clone a voice of your own (donors)."
          onClick={() => act('open_voice_studio')}
          width="100%"
          height="100%"
        />
      </Stack.Item>
      {/* ZH EDIT ADDITION END */}
    </Stack>
  );
}

export const tts_voice: FeatureChoiced = {
  name: 'Voice',
  component: FeatureTTSDropdownInput,
};

export const tts_voice_pitch: FeatureNumeric = {
  name: 'Voice Pitch Adjustment',
  component: FeatureSliderInput,
};

export const tts_blip_base: FeatureChoiced = {
  name: 'Voice Blip Base',
  component: FeatureDropdownInput,
};

export const tts_blip_number: FeatureNumeric = {
  name: 'Voice Blip Variant',
  component: FeatureSliderInput,
};

// ZH EDIT ADDITION START - TTS_EXPRESSION
export const tts_voice_instruction: Feature<string> = {
  name: 'Voice Description',
  description:
    'Describe how your TTS voice sounds: age, timbre, mood, accent or dialect. For example: a hoarse old man with a Sichuan accent. Leave empty for the plain voice.',
  component: FeatureShortTextInput,
};

export const tts_voice_rate: FeatureNumeric = {
  name: 'Voice Speed',
  description: 'How fast your TTS voice speaks, as a percentage of normal.',
  component: FeatureSliderInput,
};

export const tts_voiced_emotes: FeatureToggle = {
  name: 'Voiced Emotes',
  description:
    'Laughing, sighing, coughing, crying and other vocal emotes use your TTS voice instead of stock sound effects.',
  component: CheckboxInput,
};
// ZH EDIT ADDITION END
