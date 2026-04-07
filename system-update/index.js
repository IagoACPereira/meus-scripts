import { commandExec } from "./modules/comandExec.module.js";
import chalk from 'chalk';

new Promise(async (resolve, reject) => {
    console.log(chalk.bgBlueBright.black('\n[1/5] Atualizando repositórios...'));
    
    const command1 = await commandExec.run('sudo apt update');

    if (!command1 || !command1.includes('\'apt list --upgradable\'')) {
        return resolve('Nenhuma atualização disponível.');
    }

    const command3 = await commandExec.run('sudo apt list --upgradable');

    if (!command3) {
        return reject('Erro ao listar atualizações disponíveis.');
    }

    const softwaresToUpgrade = command3
        .trim()
        .split('\n')
        .slice(1)
        .map(line => line.split('/')[0])
        .join(' ');

    if (!softwaresToUpgrade) {
        return resolve('Nenhuma atualização disponível.');
    }

    console.log(chalk.yellowBright('\n[2/5] Instalando atualizações de pacotes...'));
    await commandExec.run(`sudo apt upgrade -y ${softwaresToUpgrade}`);

    console.log(chalk.yellowBright('\n[3/5] Atualizando Flatpak...'));    
    await commandExec.run('flatpak update -y');

    console.log(chalk.yellowBright('\n[4/5] Limpando pacotes desnecessários...'));
    await commandExec.run('sudo apt autoremove -y');
    await commandExec.run('sudo apt autoclean -y');

    console.log(chalk.yellowBright('\n[5/5] Atualizando banco de dados de arquivos...'));
    await commandExec.run('sudo updatedb');
    
    resolve('Atualização concluída com sucesso.');
})
.then(message => {
  console.log(message);
})
.catch(error => {
  console.error(error);
});